# 🎤 Presentation Notes – RecruitX Next

**Duration**: 10 mins talk + 5 mins Q&A

**Focus**: Real problems, thoughtful solutions, and evolutionary design

## Talk Flow Overview

1. Problem Statement – What's broken today
2. Architecture at a Glance – What we built and how it’s structured
3. Key Tech Choices – What & Why
4. Documentation – Evidence of depth and rigor
5. Wrap-Up – Final message
6. Q&A

## 1. Problem Statement

> Interview scheduling is broken. Recruiters at MindCompute juggle multiple tools, get no visibility, and spend hours
> manually coordinating interviews — with no fallback when things go wrong.

**RecruitX Next** is designed to automate scheduling, recover from failure, provide real-time insight and evolve with
scale — through a fallback-first, cache-driven, mesh-enabled, config-powered, and AI-augmented architecture.

## 2. Architecture at a Glance

RecruitX Next follows an **event-driven microservices architecture** — built for resilience, modularity, and
asynchronous scale. It separates concerns cleanly between matching, orchestration, and sync — ensuring failures are
isolated and recoverable by design.

### High-Level Design (HLD)

[HLD](docs/Diagrams.md)

### Key components

- **`slot-seeker`** → Responsible for intelligent matching
- **`interview-scheduler`** → Owns coordination, fallback, and notification
- **`config-service`** → Centralizes team-specific rules, dimensions, and ranking weights
- **`harvest-sync`**  → Pulls data from external systems into a cache for safe, reliable reads via Background job

### How RecruitX Components Solve Core Business Pain Points

| **Business Pain Point**                                          | **Component(s)**                         | **How It Solves the Pain**                                                          |
|------------------------------------------------------------------|------------------------------------------|-------------------------------------------------------------------------------------|
| Hard to identify interviewers with skills, availability, leave   | `slot-seeker`, `harvest-sync`            | Aggregates skills, calendar, leave into a cache; computes match using config rules  |
| No centralized view of interviewer data                          | `harvest-sync`, `dashboard`              | Periodically syncs external data into a shared TTL-backed cache for fast reads      |
| Manual slot coordination leads to double booking or missed slots | `interview-scheduler`, `DLQ`, `chatbot`  | Slot locking + retry + chatbot escalation handles happy/failure path safely         |
| Declined invites require full re-coordination                    | `DLQ`, `interview-scheduler`, `chatbot`  | Automated fallback path retries or escalates contextually without manual loss       |
| No real-time visibility into schedules or loads                  | `dashboard`, `harvest-sync`              | Cached sync of InterviewLogger/LeavePlanner + dashboard provides unified view           |
| Time-consuming manual search for interviewers                    | `slot-seeker`, `chatbot`                 | Ranked shortlist returned based on skill, availability, and config dimensions       |
| No role-to-level mapping for smart pairing                       | `config-service`                         | Defines rules for role/level per interview round to ensure proper alignment         |
| APIs are rate-limited and not performant                         | `cache-first reads`, `harvest-sync jobs` | Sync jobs with cron + MongoDB TTL eliminate need for live calls during scheduling   |
| No reporting or flow visibility                                  | `observability layer`, `dashboards`      | Logs, alerts, and dashboards enable insight into scheduling health and flow metrics |
| No automation or fallback on decline                             | `interview-scheduler`, `DLQ`, `chatbot`  | Chatbot handles manual overrides; DLQ retries ensure non-silent failures            |
| Manual communication (calendar, chat)                            | `notifier service`                       | Sends Calendar, email, and Messenger messages in real-time across stakeholders   |

## 3. Key Tech Choices – What & Why

| **Decision / Capability**         | **Why We Made It**                                                                              |
|-----------------------------------|-------------------------------------------------------------------------------------------------|
| **Event-driven via Kafka**        | Enables async workflows, decoupled services, and smooth backpressure handling                   |
| **Cache-first (Mongo TTL)**       | Prevents API overload, ensures faster reads, and supports availability during syncs             |
| **DLQ-based fallback**            | Handles failures with retries, fallback triggers, and safe escalation                           |
| **Chatbot fallback (NLP-based)**  | Allows fallback actions via chat; natural recovery without dashboards                           |
| **Service mesh with mTLS + OIDC** | Secures inter-service calls with authentication, authorization, encryption, and dynamic routing |
| **Config-driven scheduling**      | Allows rule changes (rounds, ranking, etc.) without code changes                                |
| **Configurable sync jobs**        | Enables region-wise external data fetch with cron-based control                                 |
| **Pluggable LLM adapters**        | Future-proofs AI strategy — easy to switch providers like Gemini or Ollama                      |
| **NLP-powered chatbot**           | Enhances UX with smart slot queries and fallback summarization                                  |
| **GitOps (ArgoCD + Terraform)**   | Makes deployments reproducible, auditable, and environment-consistent                           |
| **Observability & alerting**      | Logs, alerts, and dashboards ensure visibility into DLQ, jobs, and flows                        |

> RecruitX Next is designed to recover, adapt, and grow — every tech choice assumes scale, failure, and change.

## 4. Documentation

- **Architecture Characteristics** and **Tradeoffs** are explicitly documented
- **C1–C4 diagrams** modeled — from system context to code-level design
- **ADRs** capture key decisions and tradeoffs
- **Assumptions & FAQ** added to clarify gaps in the problem statement
- **Glossary** and **User Journeys** support clarity and traceability
- **Traceability Matrix** maps every design element to goals
- **AI Tools**, **Microservices**, **Tech Stack**, and **Deployment Strategy** are all independently detailed

> Wherever there was ambiguity — we documented assumptions.
> Wherever we made a decision — we wrote it down with rationale.

## 5. Wrap-Up (Closing Statement)

> RecruitX Next isn’t just a scheduler — it’s a fallback-first, event-driven system built for real-world chaos.

- Resilient by default
- Secure by design
- Modular by intent
- AI-augmented by choice

## 6. Q&A (5 mins)

**[End of Notes]**