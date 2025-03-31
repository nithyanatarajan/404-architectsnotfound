# 🧱 Architectural Characteristics – RecruitX Next

This document outlines how the architecture addresses key quality attributes, reflecting our final deployment choices,
configurability goals, and runtime resilience.

> 🔝 **Top 3 Driving Characteristics**
> 1. **Resilience** – System should absorb failures without interrupting user flows
> 2. **Configurability** – Rules and thresholds adjustable at runtime
> 3. **Observability** – Deep visibility into async, cached, and fallback paths

---

## 🔝 Top 3 Characteristics

## ✅ Resilience

**Definition**: Recover from failure and maintain workflow continuity.

- Kafka-based DLQs isolate failures and allow safe reprocessing
- Retries with exponential backoff via `tenacity` (Python) and Go context patterns
- Circuit breaker prevents repeated downstream hits
- Fallback to cached data ensures degraded-but-consistent operation
- Alerts sent to recruiters when failures affect freshness or slot computation

---

## ✅ Configurability

**Definition**: Ability to change system behavior and rules through configuration without code changes.

- Configurable scheduling logic via `config-service` (weights, round types, strategies)
- Runtime adjustment of timeouts, retry policies, and rule weights
- Feature-flag–like extensibility without redeploying services

---

## ✅ Observability

**Definition**: See, trace, and debug what's happening in the system.

- OpenTelemetry + Jaeger for distributed traces
- Logs via Loki; metrics via Prometheus; dashboards in Grafana
- Kafka emits all major state transitions
- AI and cache freshness info included in logs and alerts

---

## 🧩 Other Characteristics

## ✅ Security

**Definition**: Enforces protection and secure access to data, APIs, and communication across services.

- All user data is classified as **PII**
- OAuth2.0 + SSO with OIDC
- RBAC enforced via OPA
- mTLS and Vault for secure comms and secrets

---

## ✅ Availability

**Definition**: Remain responsive despite failures or spikes.

- Redis + fallback cache ensures read availability even during upstream downtime
- All reads use cache; API hits are only made during background refresh
- Kubernetes probes and horizontal autoscaling ensure HA behavior

---

## ✅ Scalability

**Definition**: System can increase throughput and responsiveness as load grows.

- Redis used for fast reads; refresh jobs for writes
- Services are stateless and K8s-native with autoscaling
- DLQs and circuit breakers prevent cascading failures

---

## ✅ Maintainability

**Definition**: Easy to change, operate, and evolve.

- GitOps (ArgoCD) with Helm ensures reproducible deployments
- Clear microservice boundaries with domain-aligned logic
- Safe rollback and versioned config changes via Git

---

## ✅ Extensibility

**Definition**: Plug in future functionality with minimal change.

- Support for new ATS or calendar APIs via Kong + adapters
- AI/LLM-based components (e.g., chatbot, reports) are loosely coupled and pluggable
- Gemini is used where org-approved; Ollama is supported for local testing

---

## ✅ Interoperability

**Definition**: Ensures systems can communicate consistently through open protocols and shared infrastructure.

- Unified interaction via Kong Gateway
- REST/gRPC standardization between internal services
- Kafka for async flows across systems
- Redis-backed cache reads + sync-based writes ensure separation of concern

---

## ✅ Performance

**Definition**: Low latency and fast response times.

- Redis used for sub-second slot lookups
- MongoDB used as pre-populated cache for larger query datasets
- Avoids live queries to external APIs during runtime

---

## 🧩 Additional Characteristics

### 🟡 AI Augmentation

- AI/LLM tools (e.g., Gemini, Ollama) used for summarization, anomaly alerts, and chatbot intent handling
- Outputs are non-blocking and surfaced in UI/reporting
- Tooling is provider-agnostic and modular

### 🟡 DLQ Visibility

- DLQs are exposed to authorized users via the dashboard
- Manual or automated replay mechanisms can be triggered
- Alerts are configurable and RBAC-scoped

---

✅ *This profile reflects a resilient, secure, AI-augmented cloud-native system optimized for async workflows and
human-centric override capabilities.*
