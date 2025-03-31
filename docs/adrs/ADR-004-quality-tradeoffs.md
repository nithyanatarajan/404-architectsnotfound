# ADR-004: Quality Attribute Tradeoffs

## Status

Accepted

## Context

Architectural characteristics like fault tolerance, data freshness, extensibility, and scalability had to be balanced
against delivery goals and real-world constraints.

## Decision

| Characteristic  | Tradeoff                                  | Impact                                |
|-----------------|-------------------------------------------|---------------------------------------|
| Fault Tolerance | Prioritized uptime over strict durability | DLQs and retries mitigate failure     |
| Elasticity      | Vertical scaling used for simplicity      | Acceptable due to load predictability |
| Extensibility   | Deferred multi-ATS/calendar integration   | Modular adapters can be added later   |
| Consistency     | Cached availability can be stale          | Acceptable for low-variance data      |

## Consequences

- ✅ Faster responses via caching
- ✅ Lower infra overhead
- ⚠️ Requires strong DLQ, alerting, and observability

## Alternatives Considered

- Strong consistency everywhere (too slow)
- Real-time external lookups (fragile)

## Related Docs

- [`Characteristics.md`](../Characteristics.md)
