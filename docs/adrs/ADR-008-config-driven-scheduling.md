# ADR-005: Config-Driven Scheduling Logic

## Status

Accepted

## Context

Scheduling behavior varies by team, role, and region. Hardcoding rules would restrict flexibility and make the system
brittle.

## Decision

We introduced a **config-service** to centralize runtime rules for:

- Weighting skills, time zones, and interviewer load
- Adjusting scoring dynamically
- Future feature flags or A/B variants

## Consequences

- ✅ Fine-tuned logic without code changes
- ✅ Experimentation and override support
- ⚠️ Config versioning and validation becomes critical

## Alternatives Considered

- Static YAML or ENV-based configs
- Hardcoded rules in scheduler logic

## Related Docs

- [`Microservices.md`](../Microservices.md)
