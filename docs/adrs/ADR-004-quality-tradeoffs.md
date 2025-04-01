# ADR-004: Quality Attribute Tradeoffs

## Status

Accepted

## Context

The RecruitX system must balance multiple quality attributes — availability, resilience, consistency, performance, and
extensibility — while integrating with third-party systems like Calendar, MyMindComputeProfile, and MindComputeScheduler.  
Because real-time API access cannot be guaranteed, the architecture prioritizes availability and fault tolerance through
caching and async workflows.

## Decision

| Quality Attribute | Tradeoff Made                                                                                                                                                                            |
|-------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Availability**  | Reads (e.g., slot lookup, load checks) are served from a TTL-based MongoDB sync cache. External APIs are never hit live.                                                                 |
| **Consistency**   | Cache freshness is time-bound — data may be stale up to 30 minutes (calendar) or 24 hours (MyMindComputeProfile/Leave). This is accepted in favor of fast and available responses.                     |
| **Resilience**    | Failures in Kafka workflows (e.g., interviewer assignment) are routed to DLQs. Retry policies and alerting help ensure no silent failure.                                                |
| **Performance**   | All reads are cache-based; long-running refresh jobs populate Mongo. This enables fast UX without depending on third-party latency or availability.                                      |
| **Extensibility** | Most platform rules (e.g., fallback thresholds, config weights) are defined in Mongo and served by the config service. Changes do not require service redeploys.                         |
| **Simplicity**    | Complex concerns (e.g., real-time UI sync, dynamic rescore, calendar diffing) are excluded from MVP. Only core flows with clear ownership are implemented.                               |
| **Auditability**  | All manual overrides, DLQ events, and refresh failures are logged and visualized in the dashboard with RBAC-based visibility.                                                            |
| **Security**      | PII is encrypted at rest/in transit. All admin actions (manual refresh, DLQ replay) are logged. RBAC is enforced via OPA for sensitive dashboards.                                       |
| **Scalability**   | All services are stateless and deployed to Kubernetes with autoscaling enabled. Async flows and cache reads reduce pressure on APIs and ensure readiness for 3–5x current load post-MVP. |

## Consequences

- Recruiters may receive slightly outdated slot suggestions during calendar outages or stale sync windows.
- DLQ replays may require manual inspection for failures without clear root cause.
- Operators must monitor retry, cache freshness, and system health metrics through observability tooling.
- Edge scenarios like calendar changes mid-scheduling may trigger fallback flows or alerts to recruiters.

## Alternatives Considered

- **Direct API reads for every request**  
  ✘ Rejected due to latency, quota limits, and reliability of external systems.

- **Hybrid cache + fallback API reads**  
  ✘ Overly complex and brittle; risked inconsistency and dual ownership of source-of-truth.

- **Warn-on-stale only**  
  ✔ Implemented in chatbot responses and dashboard panels via `last-refreshed` timestamps.

## Decision Drivers

- Predictable and low-latency user experience
- Graceful degradation during external failures
- Config-driven system tuning over hardcoded logic
- Full support for observability and auditability
- Future-readiness for AI enhancements without blocking core reliability

## Related Docs

- [`Characteristics.md`](../Characteristics.md)
- [`Tradeoffs.md`](../Tradeoffs.md)
