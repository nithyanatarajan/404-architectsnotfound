# ADR-002: 004 Quality Tradeoffs

## Status
Accepted

## Context

The RecruitX system needs to balance multiple quality attributes such as availability, performance, resilience,
consistency, and extensibility — all within the constraints of rapid development and integration with multiple
third-party systems (e.g., Calendar, MyMindComputeProfile, MindComputeScheduler). Given that real-time access to external systems cannot
always be guaranteed, certain tradeoffs were made to preserve user experience and platform reliability.



## Decision

| Quality Attribute | Tradeoff Made                                                                                                                                                                               |
|-------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Availability**  | Read operations (e.g., chatbot, scheduling engine) do not depend on live external APIs. Instead, they rely on a centralized read-through cache refreshed periodically.                      |
| **Consistency**   | Slight data staleness is tolerated in favor of availability. For example, calendar data may be up to 30 minutes old; MyMindComputeProfile or LeavePlanner data may be up to 24 hours old.                |
| **Resilience**    | Failures in consuming or processing Kafka messages do not block the system. Messages are rerouted to DLQs (Dead Letter Queues) for retry or manual inspection.                              |
| **Performance**   | All user-facing components are optimized to read from cache, reducing latency and avoiding API throttling.                                                                                  |
| **Extensibility** | Many platform behaviors (e.g., decline threshold, cache expiry, fallback alerting) are config-driven for future tuning.                                                                     |
| **Simplicity**    | Certain complex features (e.g., calendar UI sync, multi-tenancy, interviewer prioritization) are intentionally out of scope for this iteration.                                             |
| **Auditability**  | DLQs, manual overrides, and cache refresh triggers are logged and surfaced via the internal dashboard.                                                                                      |
| **Security**      | All data, including PII, is encrypted at rest and in transit. Access to sensitive features like DLQ inspection is governed via RBAC.                                                        |
| **Scalability**   | Services are stateless, horizontally scalable, and deployed on Kubernetes with support for autoscaling and service discovery. The system is designed to handle 3–5x of expected daily load. |


- Predictable and fast UX for recruiters
- Resilience to third-party API issues
- Operational simplicity and early integration velocity
- Extensibility via configuration
- Platform-level observability for future AI enhancements

## Related Docs

- [`Characteristics.md`](../Characteristics.md)
- [`Tradeoffs.md`](../Tradeoffs.md)


## Consequences

- Some responses (e.g., available interviewers) may use stale data during API outages or sync delays.
- Manual replay of DLQ events may be necessary in cases of permanent message failure.
- Developers and operators need observability tooling to monitor cache freshness, retry attempts, and fallback usage.
- Certain edge cases (e.g., interview slot changes after sync window) may require recruiter intervention.



## Alternatives Considered

- **Direct API reads for every request**  
  ✘ Rejected due to API rate limits, latency, and potential downtime from external services.

- **Dual-source reads (cache + API fallback)**  
  ✘ Added unnecessary complexity and risked inconsistent behavior across components.

- **Eventual consistency with stale warnings only**  
  ✔ Incorporated via cache timestamp display and recruiter alerts, but not as the only strategy.



- Option 1: ...
- Option 2: ...

## Related Docs
- TODO: Link to related ADRs or architectural docs
