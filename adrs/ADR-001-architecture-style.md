# ADR-001: Architecture Style

## Status
Accepted

## Context

The RecruitX platform must support high-scale, highly available, and decoupled interview scheduling workflows across multiple user roles (Recruiters, Interviewers, Candidates) and third-party integrations (InterviewLogger, Calendar, etc.).  
It also needs to evolve quickly, support intelligent automation, and integrate AI agents like chatbots.

Given the varied nature of responsibilities, asynchronous event handling and service-level separation are critical.

## Decision

We will adopt an **Event-Driven Microservices Architecture** with the following characteristics:

- Each microservice owns its **data and cache**
- Services communicate **asynchronously** via **Event Bus** (Kafka / Google PubSub)
- Services expose **REST APIs** only for orchestration flows and external integration
- Event contracts will be defined per domain and versioned
- Services emit **domain events** as first-class citizens
- Architecture is **stateless** wherever possible
- **Polyglot language support** is allowed (e.g., Python and Go)

## Consequences

- ✅ Enables clear domain boundaries and service autonomy
- ✅ Aligns with scalability and extensibility goals
- ✅ Encourages loose coupling and asynchronous resilience
- ⚠️ Requires discipline in event schema design and versioning
- ⚠️ Requires advanced monitoring and traceability across services
