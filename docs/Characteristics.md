# 🧱 Architectural Characteristics – RecruitX Next

This document outlines how the architecture addresses key quality attributes, reflecting our final deployment choices,
configurability goals, and runtime resilience.

> 🔝 **Top 3 Driving Characteristics**
> 1. **Configurability** – To dynamically adjust scheduling rules, weights, and flows without redeploying code
> 2. **Interoperability** – To connect with third-party systems over APIs, events, and chat
> 3. **Observability** – To provide real-time visibility, feedback, and debugging across async workflows

---

## 🔝 Top 3 Characteristics

## ✅ Configurability

**Definition**: Ability to change system behavior and rules through configuration without code changes.

- Configurable scheduling logic via `config-service` (weights, round types, strategies)
- Runtime adjustment of timeouts, retry policies, and rule weights
- Feature-flag–like extensibility without redeploying services

---

## ✅ Interoperability

**Definition**: Ensures systems can communicate consistently through open protocols and shared infrastructure.

- Unified interaction via Kong Gateway
- REST/gRPC standardization between internal services
- Kafka for async flows across systems

---

## ✅ Observability

**Definition**: See, trace, and debug what's happening in the system.

- OpenTelemetry + Jaeger for distributed traces
- Logs via Loki; metrics via Prometheus; dashboards in Grafana
- Kafka emits all major state transitions

---

## 🧩 Other Characteristics

## ✅ Extensibility

**Definition**: Plug in future functionality with minimal change.

- Add support for new ATS or calendar APIs via Kong + adapters
- UI layers (dashboard, chatbot) are loosely coupled and integration-ready

---

## ✅ Security

**Definition**: Enforces protection and secure access to data, APIs, and communication across services.

- Protect Personally Identifiable Information (PII)
- Enforce OAuth2.0, SSO, and RBAC via OIDC + OPA
- Use TLS and Vault for secure communication and secrets

---

## ✅ Scalability

**Definition**: System can increase throughput and responsiveness as load grows.

- Vertical scaling preferred due to seasonal load
- Redis-backed caching for high-performance slot lookup
- K8s-native autoscaling with optional instance-based tuning

---

## ✅ Resilience

**Definition**: Recover from failure and maintain workflow continuity.

- Retry with exponential backoff via `tenacity` (Python) and Go contexts
- Circuit breaker pattern in core APIs
- Dead-letter queues in Kafka to prevent message loss
- Fallback to cached data on external API failure

---

## ✅ Availability

**Definition**: Remain responsive despite failures or spikes.

- Redis + fallback cache avoids blocking due to upstream outages
- Kubernetes probes auto-recover failed pods
- Graceful degradation paths if InterviewLogger, Calendar, etc. are down

---

## ✅ Maintainability

**Definition**: Easy to change, operate, and evolve.

- GitOps (ArgoCD) with Helm ensures reproducible deployments
- Monitored config changes and rollback support
- Logical microservice boundaries make refactoring safe

---

## ✅ Performance

**Definition**: Low latency and fast response times.

- Redis + Mongo reduce live query times
- Pre-synced slot data avoids API bottlenecks
- Tracing and profiling enabled during runtime

---

## 🧩 Additional Characteristics

### 🟡 Feasibility

- Kafka makes the event-driven approach viable without major dependencies

### 🟡 Abstraction

- Each service owns its domain and communicates via events or APIs

---

✅ *This profile reflects a resilient, secure, and evolvable cloud-native system focused on quality-of-service and safe
extensibility.*