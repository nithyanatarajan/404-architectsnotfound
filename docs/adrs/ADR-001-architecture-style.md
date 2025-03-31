# ADR-001: Architecture Style – Event-Driven Microservices

## Status

Accepted

## Context

RecruitX must support distributed, asynchronous workflows for interview scheduling, involving multiple actors (recruiters, candidates, interviewers) and third-party systems (InterviewLogger, Calendar, etc.).

We need an architecture style that supports:

- **Loose coupling** between services
- **Scalability and fault isolation**
- **Event-driven state transitions**
- **Human-in-the-loop workflows and retries**

## Decision

We adopt **Event-Driven Microservices** as the architectural style for RecruitX Next.

This includes:

- **Kafka-based pub/sub** for workflow orchestration and event notifications
- **REST APIs** for initiating user-driven commands (e.g., schedule request)
- **CQRS-Inspired Read/Write Separation**: Commands go via APIs, views are updated via event-driven materialization
- **Service-level cache ownership** for fast local decisions without tight coupling

## Consequences

- ✅ Enables independent deployment, scaling, and fault isolation per service
- ✅ Event logs allow auditing, replay, and retry
- ✅ Natural fit for temporal workflows (e.g., RSVP updates, timeouts)
- ⚠️ Requires investment in distributed tracing and DLQ monitoring
- ⚠️ Harder to debug without proper event contracts and tooling

## Alternatives Considered

- **Monolith + REST**: Simpler initially, but limits scaling and team autonomy
- **Synchronous microservices**: Leads to cascading failures and tight coupling
- **Event Sourcing**: Overhead not justified by current domain complexity

## Related Docs

- [`ADR-002-architecture-approach.md`](./ADR-002-architecture-approach.md)
- [`ADR-003-tech-stack-choice.md`](./ADR-003-tech-stack-choice.md)
- [`ArchitectureStyle.md`](../ArchitectureStyle.md)
