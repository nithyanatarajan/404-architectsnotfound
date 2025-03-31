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
    - Webhooks from InterviewLogger
    - Sends updates to InterviewLogger

## 2. `candidate-service`

- **Responsibility:** Manages candidate interview request lifecycle
- **Consumes:**
    - API from `interviewLogger-wrapper`
    - Queries `slot-seeker` for available slots
    - Forwards selections to `interview-scheduler`

## 3. `slot-seeker` 🔥

- **Responsibility:** Computes matching slots from available data
- **Reads from:** Redis cache only; no direct external API or Mongo access
- **Note:** Cache is refreshed by `harvest-sync` jobs
- **Resilience:** Handles stale data gracefully; alerts triggered on cache sync failures

## 4. `interview-scheduler` ⚠️

- **Responsibility:** Finalizes slot assignment and generates interviewer invites
- **Consumes:** Requests from `candidate-service` or `chatbot`
- **Publishes:** Events to Kafka (e.g., `interview-scheduled`)
- **Resilience:** DLQ configured for downstream failures (e.g., slot lock, invite issue)

## 5. `notifier-service` ⚠️

- **Responsibility:** Sends notifications to interviewers/recruiters via Slack, email, or chatbot
- **Consumes:** Kafka events like scheduling, rescheduling, declines
- **Resilience:** DLQ-enabled; supports reprocessing on transient failures

## 6. `feedback-collector`

- **Responsibility:** Handles post-interview feedback intake and tracking
- **Consumes:** InterviewLogger APIs, internal Slack triggers
- **Writes to:** Mongo (optional); triggers follow-up reminders via Kafka

## 7. `chatbot` + `chatbot-interpreter` 🔥 🤖

- **Responsibility:** NLP-powered interface to help recruiters view slots, schedule interviews, and reschedule
- **Reads from:** Redis cache only
- **Intent Parsing:** Backed by custom NLP interpreter with pluggable LLM backend (e.g., Gemini, Ollama)
- **Note:** All chatbot actions are read-only or trigger commands via events

## 8. `dashboard-service`

- **Responsibility:** Provides UI-backed reports and insights for recruiters
- **Reads from:** Redis + MongoDB (via query API only)
- **Features:** Region-based filters, interview throughput, feedback rates

## 9. `harvest-sync`

- **Responsibility:** Periodically fetches data from external systems (Calendar, MindComputeScheduler, MyMindComputeProfile)
- **Writes to:** MongoDB (durable sync cache) + Redis (live read cache)
- **Schedule:** Configurable intervals (e.g., 30 mins for calendar, daily for leave/planner)
- **Resilience:** Failsafe alerting + DLQ for persistent sync issues

## 10. `config-service`

- **Responsibility:** Stores tunable weights, round logic, rule configs
- **Accessed by:** `slot-seeker`, `interview-scheduler`, `chatbot`, `dashboard`
- **Reload Strategy:** Live-reload supported; restart-free tuning

All services are stateless unless noted otherwise, and communicate via Kafka or internal APIs behind Kong Gateway. Cache
layering is strictly followed: Redis is the live read path, Mongo is a durable sync cache updated by jobs like
`harvest-sync`.

