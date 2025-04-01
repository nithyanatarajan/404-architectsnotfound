# 🧩 Microservices – RecruitX Next

> Legend

```
- 🔥 = Cache-only read layer (Redis-first)
- ⚠️ = DLQ-enabled for async failure recovery
- 🤖 = NLP/LLM enhanced
```

## 1. `interviewLogger-wrapper`

- **Responsibility:** Interface layer between InterviewLogger and internal services
- **Exposes:** Webhooks and APIs to receive candidate triggers and update schedule
- **Consumes:**
    - Webhooks from InterviewLogger whenever candidate's resume is updated
    - Sends updates related to scheduled interviews to InterviewLogger

## 2. `candidate-service`

- **Responsibility:** Manages candidate interview request lifecycle
- **Consumes:**
    - Listens to the queue from `interviewLogger-wrapper` and queries `slot-seeker` for available slots
    - Forwards the list of available slots to `mindComputeScheduler` which will send the list to candidates
    - Webhook from `mindComputeScheduler` to get the selected slots from the candidate
    - Forwards the selected slot to `interview-scheduler`

## 3. `slot-seeker` 🔥

- **Responsibility:** Computes matching slots from available data
- **Publishes:** The matching slots to the candidate service
- **Consumes:**
    - Data from `harvest-sync` and `config-service` and computes available slots
    - Gets the scheduled slots from `interview-scheduler` and updates `harvest-sync` data

## 4. `interview-scheduler` ⚠️

- **Responsibility:** Finalizes slot assignment and generates interviewer invites
  - **Consumes:**
      - Requests from `candidate-service` or `chatbot` to schedule interviews
      - Consumes `config-service` and `slot-seeker` to assign interviews
- **Publishes:** scheduled interviews to `notifier-service`
- **Resilience:** DLQ configured for downstream failures (e.g., slot lock, invite issue)

## 5. `notifier-service` ⚠️

- **Responsibility:** Sends notifications to interviewers/recruiters via messenger, email, or chatbot
- **Consumes:** Kafka events from `interview-scheduler`
- **Resilience:** DLQ-enabled; supports reprocessing on transient failures

## 6. `chatbot` + `chatbot-interpreter` 🔥 🤖

- **Responsibility:** NLP-powered interface to help recruiters view slots, schedule interviews, and reschedule
- **Consumes:**
  - Apis from `slot-seeker` and `interview-scheduler`
- **Intent Parsing:** Backed by custom NLP interpreter with pluggable LLM backend (e.g., Gemini, Ollama) for example spacy
- **Note:** All chatbot actions are read-only or trigger commands via events

## 7. `dashboard-service`

- **Responsibility:** Provides UI-backed reports and insights for recruiters
- **Consumes:**
    - Apis from `interviewLogger-wrapper`
- **Features:** Region-based filters, interview throughput, feedback rates

## 8. `harvest-sync`

- **Responsibility:** Periodically fetches data from external systems (Calendar, MindComputeScheduler, MyMindComputeProfile, Leave planner)
- **Writes to:** MongoDB (durable sync cache)
- **Schedule:** Configurable intervals (e.g., 30 mins for calendar, daily for leave/planner)
- **Resilience:** Failsafe alerting + DLQ for persistent sync issues

## 9. `config-service`

- **Responsibility:** Stores tunable weights, round logic, rule configs in mongo db
- **Accessed by:** `slot-seeker`, `interview-scheduler`
- **Reload Strategy:** Live-reload supported; restart-free tuning

All services are stateless unless noted otherwise, and communicate via Kafka or internal APIs. Mongo is a durable sync cache updated by jobs like
`harvest-sync`.

