# ADR-008: Config-Driven Scheduling Logic

## Status

Accepted

## Context

Scheduling behavior varies by team, role, and region. Hardcoding rules would restrict flexibility and make the system
brittle, especially in the face of evolving business needs or experimentation (e.g., load-balancing logic, round
preferences).

To support runtime tuning without service redeploys, we externalize all scoring and selection logic into a centralized
configuration service.

## Decision

We introduced a **config-service** to centralize runtime rules for:

- Weighting skills, time zones, and interviewer workload
- Adjusting scoring dynamically per team or scenario
- Managing scheduling round preferences (e.g., tech vs behavioral)

## Consequences

- ✅ Enables fine-tuned scheduling logic without code changes
- ✅ Supports recruiter overrides and experimentation
- ✅ Promotes separation of config and logic, aligned to 12-factor design
- ⚠️ Requires config versioning, schema validation, and audit logging
- ⚠️ Inconsistent or invalid config could impact scoring quality or availability

## Alternatives Considered

- **Static YAML or ENV-based configs**  
  ✘ Rejected due to lack of real-time reload and poor visibility into changes.

- **Hardcoded rules in scheduler logic**  
  ✘ Rejected to avoid redeploys and code-level policy entanglement.

## Related Docs

- [`Microservices.md`](../Microservices.md)
- [`ArchitectureStyle.md`](../ArchitectureStyle.md) – Configuration-Driven Principle
