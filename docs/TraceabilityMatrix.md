# 📌 Traceability Matrix – ArchKata25 Problem to Solution Mapping

This document maps key problem areas, requirements, and FAQ points from the ArchKata25 challenge to the corresponding
design decisions, artifacts, and solution components in RecruitX.

---

| Problem / FAQ Area                         | Covered In                                                                   | Notes                                                                |
|--------------------------------------------|------------------------------------------------------------------------------|----------------------------------------------------------------------|
| Interviewer skill-based matching           | `UserJourneys.md`, `Microservices.md` (InterviewerProfileService)            | Based on skill + preferred round; role mapping optional via config   |
| Interviewer availability & workload        | `AssumptionsAndFAQ.md` (Sections 1, 2), `Microservices.md`                   | Calendar + Leave + Capacity from integrated sources, via cache       |
| Leave integration (LeavePlanner)          | `AssumptionsAndFAQ.md` (Section 2), `Cache Refresh Job`                      | Polled daily; fallback on failures with alert                        |
| Rescheduling flow                          | `UserJourneys.md`, `AssumptionsAndFAQ.md` (Sections 1, 2, 4)                 | Auto-retries + fallback flow with recruiter alert                    |
| Chatbot as interface                       | `AssumptionsAndFAQ.md` (Section 4), `UserJourneys.md`                        | Supports scheduling, rescheduling, and slot lookups                  |
| NLP-driven chatbot search                  | `AssumptionsAndFAQ.md` (Section 4), `AITools.md` (planned)                   | Skill- and slot-based prompts; extensible                            |
| DLQ handling for failed events             | `AssumptionsAndFAQ.md` (Sections 3, 6), `Tradeoffs.md`, `Characteristics.md` | Kafka DLQs + dashboard visibility with RBAC                          |
| Notification handling                      | `AssumptionsAndFAQ.md` (Sections 4, 6), `UserJourneys.md`                    | Email + Messenger for recruiters; optional config for interviewers |
| Interviewer decline handling               | `AssumptionsAndFAQ.md` (Section 1), `UserJourneys.md`                        | 3x decline threshold disables auto-match temporarily                 |
| Dashboard access for recruiters            | `AssumptionsAndFAQ.md` (Sections 1, 4, 5), `Microservices.md`                | RBAC controls access to workload, reports, DLQ, alerts               |
| Reporting and interview analytics          | `AssumptionsAndFAQ.md` (Section 5), `AITools.md` (planned)                   | Load metrics, trends, reschedule reasons; CSV/PDF exports            |
| Calendar API usage                  | `AssumptionsAndFAQ.md` (Section 2), `TechStack.md`, `Security.md`            | Behind Okta SSO via OIDC; used by refresh jobs only                  |
| MindComputeScheduler integration (capacity/preference) | `AssumptionsAndFAQ.md` (Section 2)                                           | API assumed but not verified — flagged as open risk                  |
| External system failure handling           | `AssumptionsAndFAQ.md` (Sections 2, 6), `ArchitectureStyle.md`               | Cache fallback + alert after 3 failures                              |
| Scalability and load expectations          | `AssumptionsAndFAQ.md` (Section 3), `ArchitectureStyle.md`                   | 3–5x interview load supported via horizontal scaling                 |
| RBAC enforcement                           | `AssumptionsAndFAQ.md` (Sections 4, 5, 6, 7), `TechStack.md`                 | Governs access to DLQ, reports, dashboards                           |
| Compliance & PII handling                  | `AssumptionsAndFAQ.md` (Section 7)                                           | All user data treated as PII; encrypted + audit-logged               |
| Multi-tenancy support                      | `AssumptionsAndFAQ.md` (Section 3)                                           | Out of scope — single-tenant (MindCompute only)                         |
| Cache-first read architecture              | `AssumptionsAndFAQ.md` (Section 2), `Characteristics.md`, `Tradeoffs.md`     | All reads via Redis cache; refresh jobs pull data                    |
| MongoDB as sync-layer cache                | `TechStack.md`, `Microservices.md` (harvest-sync, slot-seeker)               | Durable storage of external data, supports eventual consistency      |
| Messenger Notifier integration                 | `Diagrams.md`, `UserJourneys.md`, `Microservices.md`                         | Sends notifications to recruiters via Messenger via adapter        |
| DLQ visibility via dashboard               | `Tradeoffs.md`, `Microservices.md`, `UserJourneys.md`                        | Visible to RBAC-authorized users; traceable/reschedulable            |
| Compliance traceability                    | `TraceabilityMatrix.md`, `Security.md`, `Characteristics.md`                 | Enforced encryption, access audit trails, no raw API exposure        |
