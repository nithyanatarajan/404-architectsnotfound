# 🎤 Presentation Notes – RecruitX Next

**Duration**: 10 mins talk + 5 mins Q&A

**Focus**: Real problems, thoughtful solutions, and evolutionary design

## Talk Flow Overview

1. Problem Statement – What's broken today
2. Architecture at a Glance – What we built and how it’s structured
3. Pain Points → Solution → Why It Works – Mapping user pain to design decisions
4. Key Flow – Happy path and failure recovery
5. Tech Choices – What we chose and why
6. Documentation – Evidence of depth and rigor
7. Wrap-Up – Final message
8. Q&A

## 1. Problem Statement

> Interview scheduling is broken. Recruiters at MindCompute juggle multiple tools, get no visibility, and spend hours
> manually coordinating interviews — with no fallback when things go wrong.

**RecruitX Next** is designed to automate scheduling, recover from failure, provide real-time insight and evolve with
scale — through a fallback-first, cache-driven, mesh-enabled, config-powered, and AI-augmented architecture.

## 2. Architecture at a Glance

RecruitX Next is an **event-driven microservices architecture** - designed for resilience, clarity, and independent
scalability.
Key components include:

- **`slot-seeker`** → Responsible for intelligent matching
- **`interview-scheduler`** → Owns coordination, fallback, and notification
- **`config-service`** → Centralizes team-specific rules, dimensions, and ranking weights
- **`harvest-sync`**  → Pulls data from external systems into a cache for safe, reliable reads via Background job

> Matching and orchestration are intentionally split — to keep core logic clean, reusable, and independently scalable.

## 3. Pain Points → Our Solution → Why It Works

### 1. Smart Matching & Search

| **Area**             | **Pain Point**                                                               | **Our Solution**                                                     | **Why It Works**                                             |
|----------------------|------------------------------------------------------------------------------|----------------------------------------------------------------------|--------------------------------------------------------------|
| Interviewer Matching | No unified way to match by skills, availability, leave, or round preferences | `slot-seeker` computes matches using skills, calendars, config rules | Consolidates logic; supports pluggable rules per team/region |
| Search Efficiency    | Manual, time-consuming search for available interviewers                     | API-driven filtering based on skill + config dimensions              | Returns a ranked shortlist in real-time                      |
| Role Alignment       | Matches don’t consider level/round appropriateness                           | `config-service` defines mappings by role, level, and round          | Ensures smart pairing (e.g., L4 with L4), easily adjustable  |

### 2. Scheduling & Resilience

| **Area**             | **Pain Point**                                       | **Our Solution**                                 | **Why It Works**                      |
|----------------------|------------------------------------------------------|--------------------------------------------------|---------------------------------------|
| Scheduling Conflicts | Manual rescheduling causes double bookings or delays | Slot locking + DLQ retry                         | Prevents conflicts, retries safely    |
| Decline Handling     | Recruiter manually re-coordinates on failure         | DLQ triggers chatbot fallback to nudge recruiter | Seamless recovery, no loss of context |
| Smart Escalation     | No retry/escalation unless manual                    | DLQ auto-escalates failed flows                  | No silent failures or dead-ends       |

### 3. Automation, Integration & Insight

| **Area**             | **Pain Point**                                                           | **Our Solution**                                      | **Why It Works**                                              |
|----------------------|--------------------------------------------------------------------------|-------------------------------------------------------|---------------------------------------------------------------|
| Automation Gap       | No auto-matching, No auto-selection                                      | `interview-scheduler` automates match → lock → notify | Removes recruiter from happy path; only intervenes on failure |
| Unified Visibility   | Data split across InterviewLogger, LeavePlanner, etc. with no real-time view | `harvest-sync` + TTL cache + dashboard                | All systems unified into a central view for discovery         |
| API Fragility        | External APIs availability + rate-limiting                               | Cache-first reads +background sync                    | Reduces live dependencies; stable read path                   |
| Manual Notifications | Calendar invites and alerts handled manually                             | `Notifier` automates calendar/email/chat              | Timely, consistent communication                              |
| Tracking Gaps        | No metrics or audit of interview flow                                    | Logs + dashboards                                     | Full visibility + reporting + traceability                    |

## 🔁 4. Key Flow: Scheduling + Resilience

**Happy Path**:

- Candidate triggers slot request
- Slot-seeker filters, ranks, returns options
- Scheduler locks slot, triggers notification

**Failure Path**:

- Slot lock fails → DLQ triggers retry
- If retries fail → chatbot escalates to recruiter

> We assume things will break — DLQ and fallback are default, not exceptions.

## 5. Tech Choices (What & Why)

| **Decision / Capability**       | **Why We Made It**                                                              |
|---------------------------------|---------------------------------------------------------------------------------|
| **Event-driven via Kafka**      | Decouples flows, enables async scheduling, reliable retries, and backpressure   |
| **Cache-first architecture**    | Avoids API rate limits, improves read latency using MongoDB TTL-backed cache    |
| **Chatbot fallback**            | Faster, more natural UX than traditional dashboards for recovery flows          |
| **Mesh + config-first rollout** | Enables secure, regional, team-specific routing and config without code changes |
| **GitOps deployment**           | Ensures consistency across environments using ArgoCD + Terraform                |
| **DLQ-based resilience**        | Enables structured retries, fallback escalation, and failure traceability       |
| **Configurable sync jobs**      | Configurable cron jobs allow targeted harvesting per region                     |
| **Config-driven scheduling**    | Dynamic rules without redeploys; easy to extend per team, round, or location    |
| **Pluggable LLM adapters**      | Supports evolving AI stack (Gemini, Ollama, etc.) without changing core logic   |
| **NLP-powered chatbot**         | Enhances UX via intent parsing and summarization; AI kept in UI layer only      |
| **Observability + alerting**    | Dashboards, Messenger alerts, and structured logs for DLQ + sync visibility         |
| **OIDC + mTLS security**        | Ensures secure service access and authentication across mesh-enabled services   |

> RecruitX Next is designed to recover, adapt, and grow — every tech choice assumes scale, failure, and change.

## 6. Documentation

- C1–C4 diagrams modeled, C4 down to code structure
- ADRs trace all major decisions + tradeoffs

> Everything we’ve said — we’ve documented and diagrammed.

## 7. Wrap-Up (Closing Statement)

> RecruitX Next isn’t just a scheduler — it’s a fallback-first, event-driven system built for real-world chaos.

- Resilient by default
- Secure by design
- Modular by intent
- AI-augmented by choice

## 8. Q&A (5 mins)

**[End of Notes]**