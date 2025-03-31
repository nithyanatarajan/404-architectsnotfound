# ADR-002: Architecture Approach Tradeoffs

## Status

Accepted

## Context

To meet our business goals and delivery constraints, we had to choose between major architecture strategies:

- Microservices vs monolith
- Async vs sync communication
- Polyglot services vs a single stack
- Config vs code-driven orchestration

These tradeoffs influenced system modularity, operational complexity, and team velocity.

## Decision

We chose:

- **Microservices** to enable independent evolution and bounded domains
- **Async-first workflows** using Kafka, supported by REST for command APIs
- **Polyglot services** using Go (performance) and Python (NLP/ML)
- **Per-service caching** to avoid shared bottlenecks
- **External integrations via adapters**

## Consequences

- ✅ Better alignment to ownership, scale, and SLAs
- ✅ System can evolve as services and workflows change
- ⚠️ Increased need for service discovery, tracing, and event modeling

## Alternatives Considered

- Monolith: Easier coordination but poor separation and reuse
- Fully synchronous comms: Easier to debug but tightly coupled
- Single-language stack: Reduces flexibility and tooling advantages

## Related Docs

- [`ADR-001-architecture-style.md`](./ADR-001-architecture-style.md)
- [`ADR-003-tech-stack-choice.md`](./ADR-003-tech-stack-choice.md)
