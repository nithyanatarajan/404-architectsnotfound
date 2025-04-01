# 📌 Traceability Matrix – ArchKata25 Problem to Solution Mapping

This document maps key problem areas, requirements, and FAQ points from the ArchKata25 challenge to the corresponding
design decisions, artifacts, and solution components in RecruitX.

---

| Problem / FAQ Area                         | Covered In                                                                      | Notes                                                                |
|--------------------------------------------|---------------------------------------------------------------------------------|----------------------------------------------------------------------|
| Interviewer skill-based matching           | `UserJourneys.md`, `Microservices.md` (`slot-seeker`)                           | Matching based on skills, availability, and round config             |
| Interviewer availability & workload        | `AssumptionsAndFAQ.md` (Sections 1, 2), `Microservices.md`                      | Calendar, Leave, and Capacity fetched by `harvest-sync` and cached   |
| Leave integration (LeavePlanner)          | `AssumptionsAndFAQ.md` (Section 2), `Microservices.md`, `DeploymentStrategy.md` | Polled daily via `harvest-sync`; fallback with alerting              |
| Rescheduling flow                          | `UserJourneys.md`, `AssumptionsAndFAQ.md` (Sections 1, 2, 4)                    | Retry + fallback logic with recruiter alerts                         |
| Chatbot as interface                       | `UserJourneys.md`, `AssumptionsAndFAQ.md` (Section 4)                           | Supports lookup and scheduling directly via natural language         |
| NLP-driven chatbot search                  | `AITools.md`, `UserJourneys.md`                                                 | spaCy + Transformers with optional LLM (Gemini/Ollama) integration   |
| DLQ handling for failed events             | `Characteristics.md`, `Tradeoffs.md`, `Microservices.md`                        | Kafka DLQs with dashboard visibility and RBAC scope                  |
| Notification handling                      | `UserJourneys.md`, `Microservices.md`                                           | Via Email, and Messenger (`Messenger Notifier`)                        |
| Interviewer decline handling               | `UserJourneys.md`, `Microservices.md`                                           | On decline, system retries with next best match (no threshold logic) |
| Dashboard access for recruiters            | `UserJourneys.md`, `Microservices.md`, `TechStack.md`                           | Controlled via RBAC; access to reports, alerts, DLQ                  |
| Reporting and interview analytics          | `AITools.md`, `UserJourneys.md`                                                 | Metrics, summaries, AI-powered insights, CSV/PDF exports             |
| Calendar API usage                  | `DeploymentStrategy.md`, `TechStack.md`, `Security.md`                          | Used only by `harvest-sync`; integrated via OIDC-authenticated flow  |
| MindComputeScheduler integration (capacity/preference) | `AssumptionsAndFAQ.md` (Section 2)                                              | API assumed; callout added in ADR-007                                |
| External system failure handling           | `ArchitectureStyle.md`, `Characteristics.md`                                    | 3x failure fallback + alerting; DLQs track sync issues               |
| Scalability and load expectations          | `ArchitectureStyle.md`, `Characteristics.md`                                    | Stateless services, autoscaling supported via Kubernetes             |
| RBAC enforcement                           | `TechStack.md`, `UserJourneys.md`, `Microservices.md`                           | Controls access to dashboard, DLQs, reports                          |
| Compliance & PII handling                  | `Security.md`, `Characteristics.md`                                             | PII encrypted, access logged, all data scoped to MindCompute            |
| Multi-tenancy support                      | `ArchitectureStyle.md`, `AssumptionsAndFAQ.md`                                  | Not supported – single-tenant only                                   |
| Cache-first read architecture              | `Characteristics.md`, `Tradeoffs.md`, `DeploymentStrategy.md`                   | Redis = live reads; Mongo = sync layer from external systems         |
| MongoDB as sync-layer cache                | `TechStack.md`, `Microservices.md`                                              | Durable store for MyMindComputeProfile, Calendar, MindComputeScheduler data via `harvest-sync` |
| Messenger Notifier integration                 | `UserJourneys.md`, `Microservices.md`, `Diagrams.md`                            | Separate notifier pushes alerts via Messenger to recruiters        |
| DLQ visibility via dashboard               | `Microservices.md`, `TechStack.md`, `UserJourneys.md`                           | Viewable via dashboard; replayable with RBAC control                 |
| Compliance traceability                    | `Security.md`, `TraceabilityMatrix.md`                                          | Centralized secrets, encrypted transport, audit logging              |
