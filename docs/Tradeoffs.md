# ⚖️ Architectural Tradeoffs – RecruitX Next

This document outlines the key architectural tradeoffs made during the design of the RecruitX Next system. It aims to
capture **why** certain decisions were made, and the **pros/cons** that were evaluated.

_For full rationale and decision context, refer to [ADR-004](./ADR-004-quality-tradeoffs.md)._

## 🧱 Event-Driven vs Request-Driven Architecture

**Decision**: Adopt an event-driven microservice architecture with selective use of REST APIs for synchronous
operations.

- ✅ Pros:
    - Loosely coupled services
    - Asynchronous scalability
    - Built-in support for audit/event replay
- ⚠️ Cons:
    - Requires message broker setup and monitoring (Kafka)
    - Harder to debug causal flows without observability tools
- 📌 Mitigation:
    - Used Prometheus, Grafana, Loki, OpenTelemetry for tracing
    - Used events only where eventual consistency is acceptable

---

## 🧠 Interviewer Matching Logic: Config-Driven

**Decision**: Delegate weighting strategy to a standalone `config-service` instead of hardcoding rules.

- ✅ Pros:
    - Easily tunable without code changes
    - Supports experimentation and future A/B testing
- ⚠️ Cons:
    - Risk of misconfiguration
- 📌 Mitigation:
    - Inputs are validated; config is versioned in Git

---

## 🧭 Redis + Mongo for Fast Slot Discovery

**Decision**: Use Redis for real-time slot lookups and Mongo for preloaded data.

- ✅ Pros:
    - Fast response time
    - Simplified data access layer
- ⚠️ Cons:
    - Potential data staleness
- 📌 Mitigation:
    - `harvest-sync` refreshes data on a configured schedule
    - Scheduler performs final validation

---

## 🔐 Security Layers

**Decision**: Use Kong Gateway + OIDC + OPA + Vault for end-to-end auth and access control.

- ✅ Pros:
    - Centralized control of access and policies
    - Secure secret and identity handling
- ⚠️ Cons:
    - Multi-layer setup adds operational complexity
- 📌 Mitigation:
    - Vault integrated with K8s auth
    - Policies tested independently via unit tests and policy playground

---

## 🛠️ Deployment Stack (Cloud-Agnostic)

**Decision**: Avoid cloud vendor lock-in by using Kubernetes, Helm, ArgoCD, Terraform.

- ✅ Pros:
    - Works on any cloud or on-prem
    - Declarative, GitOps-friendly
- ⚠️ Cons:
    - Requires orchestration and baseline infra setup
- 📌 Mitigation:
    - Terraform modules and Helm charts modularized

---

## 💬 Chatbot vs UI

**Decision**: Support both chatbot and dashboard for recruiter interaction.

- ✅ Pros:
    - Fast, intuitive access via ChatOps
    - Dashboard offers fallback + visibility
- ⚠️ Cons:
    - Slight duplication of intent
- 📌 Mitigation:
    - Chatbot powered by intent interpreter
    - Shared service contracts for both interfaces

---

## 🔍 Final Observation

All major decisions were made with resilience, clarity, and extensibility in mind. Where tradeoffs were needed, fallback
paths, retries, or tooling were introduced to mitigate risks.

