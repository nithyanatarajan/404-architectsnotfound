# 🧩 Microservices – RecruitX Next

> Legend

    🔥 = Cache-based read layer (MongoDB with TTL indexes)
    ⚠️ = DLQ-enabled for async failure recovery
    🤖 = NLP/LLM enhanced

## 1. `interviewLogger-wrapper`

- **Responsibility:** Interface layer between InterviewLogger and internal services
- **Exposes:** Webhooks and APIs to receive candidate events and schedule updates
- **Consumes:** Webhooks from InterviewLogger (e.g., candidate moved to “Ready to Schedule”)
- **Publishes:** Kafka topic `interviewLogger-events` (used by `candidate-service`)
- **Sends:** Updates (e.g., scheduled status) back to InterviewLogger via API

## 2. `candidate-service`

- **Responsibility:** Manages candidate interview request lifecycle
- **Consumes:**
    - Kafka topic `interviewLogger-events` (from `interviewLogger-wrapper`)
    - Webhook from MindComputeScheduler (to capture candidate slot selection)
- **Calls:**
    - `slot-seeker` for slot generation
    - MindComputeScheduler to send available slots to the candidate
    - `interview-scheduler` after candidate selects a slot
- **Publishes:** Kafka topic `interview-schedule-queue`

## 3. `slot-seeker` 🔥

- **Responsibility:** Computes valid time slots for requested rounds
- **Consumes:**
    - Availability, leave, preferences from `harvest-sync` (via MongoDB)
    - Round rules and weights from `config-service`
- **Publishes:** Valid slots to `candidate-service`
- **Updates:** Harvested cache if needed based on feedback from `interview-scheduler`

## 4. `interview-scheduler` ⚠️

- **Responsibility:** Finalizes slot assignment and assigns optimal interviewer
- **Consumes:**
    - Kafka topic `interview-schedule-queue`
    - Data from `slot-seeker` and `config-service`
- **Publishes:** Events to `notifier-service`
- **Resilience:** DLQ-enabled for failures such as slot lock errors or calendar sync issues

## 5. `notifier-service` ⚠️

- **Responsibility:** Sends multi-channel notifications for interview events
- **Consumes:** Kafka events from `interview-scheduler`
- **Notifies:**
    - Calendar (invites)
    - Messenger (alerts)
    - Email (fallback/manual)
- **Resilience:** DLQ-backed with ability to retry transient failures

## 6. `chatbot` + `chatbot-interpreter` 🔥 🤖

- **Responsibility:** NLP-powered interface to help recruiters view slots, schedule interviews, and reschedule (Google
  Chat-based)
- **Consumes:**
    - Recruiter queries like "Who’s free for a Java interview tomorrow?"
    - Internal APIs: `slot-seeker`, `interview-scheduler`
- **Intent Parsing:** Backed by custom NLP interpreter with pluggable LLM backend (e.g., Gemini, Ollama)
- **Note:** All chatbot actions are read-only or trigger commands via events

## 7. `dashboard-service`

- **Responsibility:** Web-based recruiter interface (read-only in MVP)
- **Consumes:**
    - Internal APIs to query schedule status, interviewer load, reschedules, etc.
    - `interviewLogger-wrapper` for candidate state view
- **Features:** Region-based filters, daily/weekly analytics, feedback turnaround time, DLQ and alert visibility

## 8. `harvest-sync`

- **Responsibility:** Periodically fetches data from external systems (Calendar, MindComputeScheduler, MyMindComputeProfile, LeavePlanner)
- **Writes to:** MongoDB (durable sync cache with TTL-based expiry)
- **Schedule:** Configurable intervals (e.g., 30 mins for Calendar, 24h for Others)
- **Resilience:** Failsafe alerting + DLQ for persistent sync issues ⚠️

## 9. `config-service`

- **Responsibility:** Stores runtime-tunable configs: weights, rules, preferences, round-specific scoring logic
- **Reads/Writes:** MongoDB (with reload support)
- **Accessed by:** `slot-seeker`, `interview-scheduler`

## 🔐 Communication & Mesh

- All services are stateless unless otherwise noted
- Service-to-service calls and API access are secured using:
    - 🔐 **mTLS** (via Consul + Envoy)
    - 🔐 **OIDC** (via Okta)
    - 🔐 **OPA** for policy enforcement (RBAC)
- Message flow is asynchronous wherever possible using Kafka topics with DLQs

