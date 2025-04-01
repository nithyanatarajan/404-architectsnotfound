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
- Fallback to cached data ensures degraded-but-consistent operation (MongoDB TTL cache)
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
- mTLS and Vault (or internal secret manager) for secure comms and secrets

---

## ✅ Availability

**Definition**: Remain responsive despite failures or spikes.

- MongoDB with TTL-based cache ensures read availability even during upstream downtime
- All reads use the local cache; API hits are performed only during background refresh jobs
- Kubernetes probes and horizontal autoscaling ensure HA behavior

---

## ✅ Scalability

**Definition**: System can increase throughput and responsiveness as load grows.

- MongoDB handles high-volume cache reads efficiently
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

- Support for new ATS or calendar APIs via adapters
- AI/LLM-based components (e.g., chatbot, reports) are loosely coupled and pluggable
- LLM provider (e.g., Gemini, Ollama) is configurable based on org preference

---

## ✅ Interoperability

**Definition**: Ensures systems can communicate consistently through open protocols and shared infrastructure.

- REST/gRPC standardization between internal services
- Kafka for async flows across systems
- MongoDB (cache) separates fetch logic from compute paths
- All services operate inside a secure, authenticated internal mesh

---

## ✅ Performance

**Definition**: Low latency and fast response times.

- MongoDB TTL cache used for near-real-time slot lookups
- Background sync avoids blocking user flows with external calls
- Optimized read-write separation for scheduling and matching logic

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
