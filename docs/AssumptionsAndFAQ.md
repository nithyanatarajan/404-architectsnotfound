# 📄 Assumptions and FAQ – RecruitX

## 1. Functional Requirements & Business Rules

### ❗Assumptions

- The system **automatically reschedules** interviews upon decline and notifies the recruiter only if it fails to find a
  new slot.
- Interviewer **matching is based on skills and preferred interview rounds** by default, as per ArchKata25 scope. Other
  dimensions are supported as a configurable enhancement in our system.
- Interviewer workload (e.g., interviews per week/month) is **fetched from MindComputeScheduler** (or equivalent) and may be *
  *further
  validated/configured** within the system.
- **Recruiters can view interviewer workload and schedule history** via the dashboard.
- Interview slots are shown only if they meet all the following: **skill match, availability, leave status, and within
  workload limits**.

### ✅ Decisions

- Recruiters have the option to **manually override** system-selected interviewers in edge or fallback scenarios.
- If an interviewer **declines 3 interview requests consecutively**, the system will **temporarily remove them from
  auto-matching** and notify the recruiter.  
  📌 *This is a team-defined policy to avoid repeated declines and is configurable.*
- **Hiring urgency is defined manually by recruiters.** The system does not prioritize based on urgency signals.

### ❓ Open Questions

- Should the system track **historical decline rates** for interviewers as part of long-term analytics/reporting?
- Should fallback interviewer suggestions be **ranked by past acceptance rate**, calendar health, or just
  skills/availability?

## 2. Integrations & Data Flow

### ❗Assumptions

- **Calendar** is the only supported calendar provider initially. Integration assumes:
    - **API-level access is available behind MindCompute's Okta SSO**
    - Authentication and authorization handled using **OIDC/OAuth2**
    - Access tokens and scopes are managed per user with proper refresh flows
- Interviewer-related data is sourced from:
    - **MyMindComputeProfile** for skillsets and preferences
    - **MindComputeScheduler (or equivalent)** for interview capacity and preferred time slots  
      ⚠️ Assumes API availability — no official contract/docs currently available
    - **LeavePlanner** for leave status
    - **Calendar** for real-time slot availability
- External systems are assumed to **not expose webhooks**, and data will be pulled via **polling** unless webhooks are
  discovered later.

### ✅ Decisions

- A **read-through cache** is implemented and treated as the **primary data source** for interviewer information.
- **All system components** (chatbot, scheduler, dashboard) read from cache only.
- A **background refresh job** fetches from each external system on a configured interval:
    - Calendar: every 30 minutes
    - MyMindComputeProfile / MindComputeScheduler / LeavePlanner: every 24 hours
- If a refresh job fails:
    - A recruiter-facing alert is raised
    - The system continues to serve cached data
- If a refresh job fails **3 consecutive times** (configurable):
    - A system-level error is logged
    - Critical flows dependent on that data may be temporarily paused
- All API interactions with external systems are handled by the refresh job; user-facing components never call APIs
  directly.
- Chatbot responses include **last-updated timestamps** to show data freshness.

### ❓ Open Questions

- Should recruiters be able to **trigger a manual cache refresh** in edge cases?
- If MindComputeScheduler API access is not granted, what is our **fallback plan** for syncing workload/capacity data?

## 3. Architecture & Scalability Considerations

### ❗Assumptions

- The solution is designed as a **single-tenant system** for MindCompute (multi-tenancy is out of scope).
- The expected initial load:
    - ~100 interviews/day
    - ~10,000 interviewers
    - ~500 recruiters
- The system should scale horizontally and support **3–5x anticipated load** without significant redesign.

### ✅ Decisions

- The system follows an **event-driven microservices architecture**, using **Kafka** for asynchronous communication
  between services.
- All critical Kafka topics (e.g., interview-scheduled, cache-refresh) are configured with **Dead Letter Queues (DLQs)**
  to isolate failed events.
- **DLQ metrics and messages will be surfaced in the internal dashboard**, with visibility governed via RBAC (
  configurable per role/team).
- Consumers implement **retry mechanisms with exponential backoff**, and **circuit breakers** to prevent cascading
  failures.
- Services are designed to be **stateless and horizontally scalable**, deployable on Kubernetes with support for
  autoscaling and service discovery (via Kubernetes DNS or Consul).
- Workflows are **idempotent**, allowing retries without data inconsistency.
- Rate limiting and **bulkhead isolation** are used to protect key services (e.g., integrations).
- Full-stack observability is built in via **Prometheus, Grafana, Loki, and Jaeger**.

### ❓ Open Questions

- Should DLQ messages support **manual replay only**, or allow **configurable auto-retry** after a delay?
- Should we introduce **priority-based queues** for urgent cases (e.g., same-day interview reschedules)?
- Is **multi-region DR** required at this stage, or should it be explicitly scoped out?

## 4. Chatbot, Notifications & UX Strategy

### ❗Assumptions

- The **chatbot is designed exclusively for recruiters**; candidates and interviewers do not interact with it (as per
  ArchKata25 scope).
- It is integrated into **Messenger Space** and supports **natural language queries** for recruiter convenience.
- Primary notification types include:
    - Interview scheduled
    - Interview rescheduled
    - Interview declined or fallback used
    - External sync failures (e.g., data not refreshed)
- **Email is the primary notification channel**, with Messenger used for quicker, conversational alerts.
- The chatbot and notification systems **do not directly call external APIs** — all reads are via the **central cache**.

### ✅ Decisions

- The chatbot acts as an **interactive assistant** — recruiters can use it to **initiate actions** such as scheduling,
  rescheduling, or checking interviewer availability.
- All chatbot responses include **cached timestamps** when data freshness is relevant (e.g., availability or load).
- Chatbot capabilities include:
    - Skill and slot-based queries (e.g., “Who’s available for Python today?”)
    - Interview scheduling (e.g., “Schedule Python interview for tomorrow at 3 PM”)
    - Rescheduling prompts (e.g., “Reschedule 3 PM for John”)
    - Interview load insights (e.g., “Show top 3 interviewers for React next week”)
- Chatbot interaction is stateless; context is handled via **message threads or pinned cards** in Messenger.
- Critical alerts are sent via **chat and email** to recruiters. Alert content includes context (e.g., stale data,
  failed sync).
- Interviewers will get access to a **read-only dashboard** to view their upcoming interviews (RBAC will determine exact
  visibility).
- Notification services are **resilient** with retry logic and delivery confirmation for time-sensitive events.

### ❓ Open Questions

- Should the chatbot support additional **actionable commands** (e.g., cancel, reassign)?
- Should **notification escalation** (e.g., email or SMS) be added if recruiter doesn’t acknowledge within a time
  window?
- Should interviewers also receive **chat-based alerts**, or should this remain email-only?  
  ✅ *This can be handled as a system-level configuration per org/team preference.*

## 5. Reporting & Performance Metrics

### ❗Assumptions

- Recruiters need visibility into key interview lifecycle metrics, such as:
    - Interview completion rate
    - Interviewer load (assigned vs. completed)
    - Rescheduling frequency and reasons
- Reports are intended **only for recruitment personnel**, not accessible to others.
    - Within the recruitment org, access to reports is **governed via RBAC**, which reflects the organizational
      hierarchy (
      e.g., global, region, country, recruiter-level).
- Reports do not need to support live actions (e.g., "reschedule from here"), but the system is designed to allow such
  extensions.
- There are no explicit **compliance/legal data retention constraints** defined in ArchKata25 — can be assumed as
  team-defined.

### ✅ Decisions

- The system generates **daily and on-demand reports**, covering:
    - Interviews scheduled, completed, cancelled, or declined
    - Interviewer utilization and load distribution
    - Decline reasons and fallback frequency
    - Reschedule volume over time
- Reports are accessible via the **recruiter dashboard** and exportable as CSV/PDF.
- A **reporting database** is maintained separately (e.g., PostgreSQL or OLAP-friendly DB), optimized for aggregation
  and trend queries.
- Metrics are generated from **event streams** (e.g., interview-scheduled, rescheduled) and stored in a **central
  reporting sink**.
- **SLA-based alerts** are triggered for violations (e.g., no feedback after 24h, failed calendar sync).
- All interview-related data is retained for at least **90 days** (configurable).

### ❓ Open Questions

- Should the reporting dashboard support **filtering by recruiter, skill, or role** in the initial version?
- Should any reports include **candidate feedback and outcomes** (e.g., passed/failed) for analysis?

## 6. Security & Reliability

### ❗Assumptions

- The system must handle **interviewer and candidate data** responsibly, though **no specific compliance requirements
  ** (e.g., GDPR, SOC2) are stated in ArchKata25.
- RBAC (Role-Based Access Control) will be used to restrict access to reports, dashboards, DLQs, and sensitive
  operations.
- Chatbot, dashboards, and backend APIs are internal tools, **not exposed to external users** (e.g., candidates).

### ✅ Decisions

- **OAuth2 and JWT** are used for authentication and session validation across services.
- **RBAC enforcement** is implemented for:
    - Recruiter dashboards
    - Access to DLQs and logs
    - Reporting filters (region/country/individual-level access)
- Sensitive actions (e.g., manual override of schedules, cache refresh triggers) are **audit-logged** for traceability.
- Interviewer and scheduling data is encrypted **at rest** and **in transit** using TLS.
- Calendar API failures or data sync issues trigger:
    - **3 retry attempts** with exponential backoff
    - If still failing → fallback to cached data and **alert to recruiter**
- Repeated failures (e.g., 3+ consecutive cache refresh failures) escalate to **system alerts** and are surfaced in the
  dashboard.
- **Circuit breakers** and retry policies are used to isolate downstream integration issues (e.g., with MyMindComputeProfile, Leave
  Planner).

### ❓ Open Questions

- Should compliance features (e.g., data retention policies, right-to-be-forgotten) be considered even if not required
  initially?
- Should all recruiter actions (e.g., chatbot-triggered scheduling) be **audit-logged** at fine granularity?
- Should login and access logs be retained beyond standard application logs, for security audit purposes?

## 7. Compliance Considerations

### ❗Assumptions

- The ArchKata25 problem statement does **not explicitly specify** regulatory requirements such as GDPR, SOC 2, or
  HIPAA.
- **All user data — including candidate, interviewer, and recruiter information — is treated as PII** by default.
- Data protection and compliance policies (e.g., retention periods, deletion rules) will be governed by MindCompute’s
  internal guidelines.

### ✅ Decisions

- All personally identifiable information (PII) — including email addresses, schedules, preferences, feedback, etc. —
  is:
    - **Encrypted at rest**
    - **Encrypted in transit** using TLS
    - **Access-controlled** via RBAC based on user role and hierarchy
- A system-wide **audit log** records sensitive operations such as:
    - Manual overrides
    - Interviewer reassignment
    - DLQ inspection
    - Cache refresh overrides
- Default **data retention policy** is 90 days (configurable per event type or policy update).
- The architecture is designed to support future compliance requirements like:
    - **Right to be forgotten**
    - **Selective data deletion**
    - **Access audit logs** per user or action

### ❓ Open Questions

- Should different data types (e.g., scheduling logs, feedback, chatbot queries) have **separate retention timelines**?
- Should we support **on-demand data export** for audit or compliance review?
- Should **PII masking** or redaction be built into logs or reports by default?
