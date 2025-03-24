# ADR-004: Tech Stack Choices

## Status

Accepted

## Context

Given the variety of services in RecruitX, no single language or framework is ideal for all use cases.  
We need a performant, flexible stack that supports AI workloads, real-time scheduling, and rapid prototyping.

## Decision

We will adopt a **polyglot stack** using both Python and Go, chosen per service domain:

| Service Type                | Language + Framework |
|-----------------------------|----------------------|
| Chatbot, Config, Reporting  | Python + FastAPI     |
| Matcher, Slot Recommender   | Go + Fiber           |
| Availability Evaluator      | Go + Fiber           |
| Auth Gateway, Event Adapter | Go + Fiber           |
| Web Dashboard               | Flutter (UI)         |

Other shared tools:

- **Kafka / PubSub** for messaging
- **PostgreSQL** for transactional data
- **Redis** for low-latency caching
- **Prometheus + Grafana** for observability
- **Jaeger + OpenTelemetry** for tracing
- **Docker + Kubernetes + GoCD** for CI/CD

## Consequences

- ✅ Each service uses the best-fit tech
- ✅ Python allows rich AI integration
- ✅ Go ensures fast and efficient concurrency
- ⚠️ DevOps complexity increases with two language stacks
- ⚠️ Shared tooling and contract discipline becomes critical
