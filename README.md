# RecruitX Next – Interview Scheduling Platform | Architectural Kata 2025

> The comeback of a loved tool—redesigned, reimagined.

Welcome to our architectural submission for **ArchKata 25**. RecruitX Next is a resilient, extensible, and observable
interview scheduling platform that automates recruiter workflows and provides fallback mechanisms for real-world edge
cases.

---

## 📌 Problem Statement

Recruiters at MindCompute are spending far too much time manually coordinating interviews—matching skills, checking
availability, avoiding scheduling conflicts, and handling declines. The current process involves multiple systems
(InterviewLogger, MindComputeScheduler, MyMindComputeProfile, LeavePlanner) but no centralized intelligence or automation. The result? Missed
interviews, double bookings, rescheduling chaos, frustrated interviewers and candidates.

Our goal is to streamline and automate the **interviewer discovery**, **scheduling**, **rescheduling**, and
**notification flow** with a smart, integrated system and chatbot interface—reducing manual effort and accelerating
the hiring process.

---

## Resources

This repository documents the architecture, design rationale, and implementation strategy for **RecruitX Next**, our
scalable, cache-first interview scheduling system submitted for ArchKata 2025.

---

## ✨ Solution Highlights

- 🔁 **Cache-as-Primary Reads**: Redis powers all live reads; external data sync is background-only
- 💬 **Multichannel Interface**: Recruiters interact via Web UI, Slack, and Chatbot
- ⚡ **DLQ + Alerting Built-In**: Resilient retries and manual fallback for all critical paths
- 🧠 **LLM-Enhanced**: NLP/LLM augment chatbot and reporting — provider-agnostic and pluggable
- 🛡️ **Secure by Design**: OIDC + OPA + Vault + mTLS across mesh-enabled services

---

## 📌 Overview

- **Architecture Style**: Event-driven microservices
- **Key Characteristics**: Resilient, Observable, Configurable, AI-augmented
- **Deployment**: GitOps-first, Kubernetes-native, Cloud-agnostic
- **Security**: OIDC + OPA + mTLS + Vault
- **Tech Stack**: Go, Python, Kafka, Redis, Mongo, Flutter, Gemini/Ollama, ArgoCD, Consul

---

## 🧱 Architecture Diagrams

| Diagram         | Status     | File                                              |
|-----------------|------------|---------------------------------------------------|
| C1 – Context    | ✅ Complete | [`SystemContext.png`](./images/SystemContext.png) |
| C2 – Containers | 🔲 Pending | _(To be finalized)_                               |
| C3 – Components | 🔲 Pending | _(To be finalized)_                               |
| C4 – Code Map   | 🔲 Pending | _(To be finalized)_                               |

See [`Diagrams.md`](./docs/Diagrams.md) for a visual index and evolution notes.

---

## 🔧 Core Design Documents

| Document                                                | Description                                          |
|---------------------------------------------------------|------------------------------------------------------|
| [`ArchitectureStyle.md`](./docs/ArchitectureStyle.md)   | Overall architecture patterns and principles         |
| [`Characteristics.md`](./docs/Characteristics.md)       | System quality attributes & non-functionals          |
| [`Tradeoffs.md`](./docs/Tradeoffs.md)                   | Design tradeoffs and justifications                  |
| [`Techstack.md`](./docs/Techstack.md)                   | Tech stack choices and rationale                     |
| [`AITools.md`](./docs/AITools.md)                       | LLM/NLP strategy, pluggable tooling                  |
| [`DeploymentStrategy.md`](./docs/DeploymentStrategy.md) | GitOps, Helm, Terraform, K8s setup                   |
| [`Microservices.md`](./docs/Microservices.md)           | Domain-driven service breakdown with cache/DLQ roles |

---

## 📘 Reference Docs

| Document                                              | Description                                   |
|-------------------------------------------------------|-----------------------------------------------|
| [`Glossary.md`](./docs/Glossary.md)                   | Roles and domain terms used across the system |
| [`UserJourneys.md`](./docs/UserJourneys.md)           | Key User Journeys                             |
| [`AssumptionsAndFAQ.md`](./docs/AssumptionsAndFAQ.md) | Assumptions, Functional Decisions and FAQs    |

---

## 🔍 Traceability

Refer to [`TraceabilityMatrix.md`](./docs/TraceabilityMatrix.md) for complete mapping of:

- Functional & non-functional requirements
- Design elements & supporting decisions
- AI and external system integrations

---

## 📚 ADRs – Reading Order

| ADR #   | Filename                                                                                 | Title                                      |
|---------|------------------------------------------------------------------------------------------|--------------------------------------------|
| ADR-001 | [ADR-001-architecture-style.md](./docs/adrs/ADR-001-architecture-style.md)               | Architecture Style                         |
| ADR-002 | [ADR-002-architecture-approach.md](./docs/adrs/ADR-002-architecture-approach.md)         | Architecture Approach                      |
| ADR-003 | [ADR-003-tech-stack-choice.md](./docs/adrs/ADR-003-tech-stack-choice.md)                 | Tech Stack Choice                          |
| ADR-004 | [ADR-004-quality-tradeoffs.md](./docs/adrs/ADR-004-quality-tradeoffs.md)                 | Quality Tradeoffs                          |
| ADR-005 | [ADR-005-cache-as-primary-read.md](./docs/adrs/ADR-005-cache-as-primary-read.md)         | Cache-as-Primary Read Strategy             |
| ADR-006 | [ADR-006-dlq.md](./docs/adrs/ADR-006-dlq.md)                                             | DLQ Strategy for Kafka Workflows           |
| ADR-007 | [ADR-007-external-systems-raid.md](./docs/adrs/ADR-007-external-systems-raid.md)         | External Integration Assumptions and Risks |
| ADR-008 | [ADR-008-config-driven-scheduling.md](./docs/adrs/ADR-008-config-driven-scheduling.md)   | Config-Driven Scheduling                   |
| ADR-009 | [ADR-009-service-mesh-consul-envoy.md](./docs/adrs/ADR-009-service-mesh-consul-envoy.md) | Service Mesh – Consul + Envoy              |
| ADR-010 | [ADR-010-gitops-argocd.md](./docs/adrs/ADR-010-gitops-argocd.md)                         | GitOps with ArgoCD                         |
| ADR-011 | [ADR-011-shift-left-security.md](./docs/adrs/ADR-011-shift-left-security.md)             | Shift-Left Security                        |
| ADR-012 | [ADR-012-nlp-chatbot.md](./docs/adrs/ADR-012-nlp-chatbot.md)                             | NLP Chatbot Capabilities                   |
| ADR-013 | [ADR-013-manual-dashboard-fallback.md](./docs/adrs/ADR-013-manual-dashboard-fallback.md) | Manual Dashboard Fallbacks                 |

---

## ✅ Submission Checklist (as per ArchKata25)

- [x] C1 – System Context Diagram
- [ ] C2 – Container Diagram
- [ ] C3 – Component Diagram
- [ ] C4 – Code Mapping / Deployment View
- [x] Architecture characteristics documented
- [x] Tradeoffs explained and justified
- [x] ADRs structured and referenced
- [x] Assumptions and integration risks covered
- [x] AI & LLM usage called out, with fallback strategy
- [x] Deployment choices documented (GitOps, Terraform, Helm)

---

## 🧠 Summary

🚀 RecruitX Next is built to scale, recover, adapt, and empower — designed for real-world interview coordination at
scale.

It embraces event-driven principles, secure API access, cache-first reads, observable workflows, and fallback-driven
resilience — all while enabling AI-augmented decision-making through chatbot and reporting tools.


> This repository is our ArchKata 25 response. All docs and decisions reflect architectural thinking, not
> implementation.

> Please find the zoom recording about the explanation of our High level design here ->
> https://thoughtworks.zoom.us/rec/share/ufO5CRt8eDqcsHBrBaX-5Vx_v7KGSagWUdRIdv_Jb9zLnkbAICMlLqXavJ5xPp0K.QGk6K786UQf0w6Z9
> Passcode: 1=ww!e16

Thank you for reviewing!

