# 🧩 Microservices – RecruitX Next

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

## 3. `slot-seeker`

- **Responsibility:** Matches slots based on candidate tech stack and round using Redis cache
- **Consumes:**
    - MongoDB via `harvest-sync` (used as cache only)
    - API from `candidate-service`
- **Exposes:**
    - Slot availability for downstream services
- ℹ️ Note: Data is considered temporal. Final slot conflict resolution is handled by the `interview-scheduler`.

## 4. `interview-scheduler`

- **Responsibility:** Orchestrates interview setup, interviewer selection, persistence, retries, and rescheduling
- **Consumes:**
    - Slot + tech stack from `candidate-service`
    - Config weights from `config-service`
    - Calendar responses from `notifier-service`
- **Stores:** MongoDB (used as durable cache)
- **Exposes:**
    - Event publishing to Kafka
- ✅ Final selector of interviewer based on latest slot & config context

## 5. `notifier-service`

- **Responsibility:** Generates and dispatches calendar invites, links, status alerts, and chat messages
- **Consumes:**
    - Queue events from `interview-scheduler`
    - Webhook responses from Calendar
- **Sends:**
    - Emails to candidate
    - Calendar invites to interviewers
    - Messenger notifications to recruiters and interviewers (via Messenger API)

## 6. `dashboard`

- **Responsibility:** Recruiter-facing UI to view interview progress and take manual actions
- **Consumes:**
    - Kafka events for interview status
- **Supports:**
    - Manual override of scheduler (via API)
    - Manual action flow enabled

## 7. `chatbot` + `chatbot-interpreter`

- **Responsibility:** Natural language interface for recruiters
- **Consumes:**
    - API → `slot-seeker`, `interview-scheduler`
- **Handles:**
    - Booking, rescheduling, cancellations, intent parsing

## 8. `harvest-sync`

- **Responsibility:** Scheduled job to pull data from external systems and populate MongoDB
- **Data Sources:** MindComputeScheduler, MyMindComputeProfile, Calendar, LeavePlanner
- **Frequency:**
    - Calendar: every 30 minutes
    - MyMindComputeProfile/LeavePlanner: daily (configurable)
- **Publishes:** Kafka messages for downstream consumers

## 9. `config-service`

- **Responsibility:** Stores configurable weights and rules for interviewer matching
- **Stores:** MongoDB (acts as source of truth)
- **Consumes:** API requests from `interview-scheduler`

---

## Event-Driven Communication Summary

| Event                     | Publisher             | Consumers                       |
|---------------------------|-----------------------|---------------------------------|
| `AvailableSlotsGenerated` | `slot-seeker`         | `candidate-service`             |
| `InterviewRequested`      | `candidate-service`   | `interview-scheduler`           |
| `InterviewScheduled`      | `interview-scheduler` | `notifier-service`, `dashboard` |
| `InterviewDeclined`       | `notifier-service`    | `interview-scheduler`           |
| `InterviewRescheduled`    | `interview-scheduler` | `notifier-service`, `dashboard` |
| `ManualActionRequired`    | `interview-scheduler` | `dashboard`                     |

## 🌐 External Systems

| System          | Type         | Integrated Via         |
|-----------------|--------------|------------------------|
| Calendar | Calendar API | Webhook + Harvest Sync |
| InterviewLogger      | ATS          | API + Webhook Adapter  |
| MindComputeScheduler        | External     | Harvest Sync           |
| LeavePlanner   | Internal     | Harvest Sync           |
| MyMindComputeProfile          | Internal     | Harvest Sync           |
| Messenger           | Messaging    | Notifier + Chatbot     |
| Email           | Messaging    | Notifier Service       |
