# ADR-002: Architecture Tradeoffs

## Status

Accepted

## Context

While designing RecruitX, we considered several architectural and design tradeoffs, especially between monoliths vs
microservices, sync vs async communication, and single vs multi-language stacks.

## Decision

Here are the key tradeoffs accepted as part of our architecture:

| Decision Area                    | Tradeoff Description                                                         | Final Choice                        |
|----------------------------------|------------------------------------------------------------------------------|-------------------------------------|
| Monolith vs Microservices        | Microservices provide flexibility, but increase operational overhead         | ✅ Microservices                     |
| Sync vs Async Communication      | Async allows decoupling and retries, but makes debugging harder              | ✅ Event-driven (async-first)        |
| Language Stack                   | Go offers speed, Python offers ML/NLP tooling                                | ✅ Hybrid (Go + Python)              |
| Central vs Distributed Cache     | Distributed cache is harder to manage but avoids shared bottlenecks          | ✅ Per-service cache                 |
| Manual vs AI-driven interactions | Manual config is deterministic, AI chatbot improves UX                       | ✅ Chatbot + dynamic flows           |
| Custom Scheduler vs MindComputeScheduler     | Building from scratch offers control, MindComputeScheduler simplifies calendar workflows | ✅ Integrate with MindComputeScheduler (for now) |

## Consequences

- ✅ Architecture will be more scalable and maintainable
- ⚠️ Onboarding and observability will be more complex
- ⚠️ Some cross-service logic must be handled via well-documented event contracts
