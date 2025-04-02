# ⚖️ Architectural Tradeoffs – RecruitX Next

This document outlines the key architectural tradeoffs made during the design of the RecruitX Next system. It aims to
capture **why** certain decisions were made, and the **pros/cons** that were evaluated.

_For full rationale and decision context, refer to [ADR-004](./adrs/ADR-004-quality-tradeoffs.md)._

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

## 🧭 MongoDB as Durable Cache with TTL

**Decision**: Use MongoDB with TTL indexing for slot availability and interviewer profile caching.

- ✅ Pros:
    - TTL allows controlled data expiry without Redis
    - Mongo serves both cache and config needs
- ⚠️ Cons:
    - Slightly higher read latency than Redis in high-throughput scenarios
- 📌 Mitigation:
    - TTL indexing keeps cache fresh
    - Harvest-sync jobs run on defined intervals (30min/24hr split)

---

## 🔐 Security Layers

**Decision**: Use OIDC + OPA + Vault for authentication, authorization, and secrets.

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
