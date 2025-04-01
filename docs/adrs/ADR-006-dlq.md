# ADR-004: 006 Dlq

## Status
Accepted

## Context

The RecruitX platform uses Kafka for asynchronous communication between services, enabling decoupled processing of
events like interview scheduling, rescheduling, declines, and cache refreshes. To improve resilience and observability
in case of downstream or consumer failures, we introduce **Dead Letter Queues (DLQs)** for all critical Kafka topics.

DLQs allow us to isolate failed messages, inspect them without blocking live flows, and optionally replay them after
intervention.



## Decision

|-------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **DLQ Topics**                | For each critical Kafka topic (e.g., `interview-scheduled`, `cache-refresh`), a corresponding `*-dlq` topic is defined.                                        |
| **Failure Threshold**         | A message is pushed to DLQ after **3 failed retries** with exponential backoff. Retry count is configurable.                                                   |
| **Message Replay**            | DLQ messages can be **manually replayed** via an internal tool or CLI. Auto-replay with throttling may be added later.                                         |
| **Alerting**                  | DLQ volumes and error types are surfaced in the internal dashboard. Recruiters/admins are alerted if failure impacts data freshness or scheduling workflows.   |
| **DLQ Visibility**            | DLQ access and visibility is controlled via **RBAC**. Not all users can replay or inspect contents.                                                            |
| **Error Logging**             | All DLQ messages are logged with the original payload, failure reason, and retry metadata for debugging.                                                       |
| **Idempotency Requirement**   | Consumers are designed to be **idempotent** so DLQ replays do not cause duplication or state corruption.                                                       |
| **Examples of DLQ scenarios** | - MyMindComputeProfile API unreachable during refresh<br>- Interview schedule creation fails due to missing interviewer<br>- Rescheduling logic fails due to race conditions |


- Need for **workflow continuity** even when partial failures occur
- Ability to **observe, debug, and replay** failures without user disruption
- Alignment with event-driven patterns and resilience principles
- Operator confidence and safety controls

## Related Docs

- [`AssumptionsAndFAQ.md`](../AssumptionsAndFAQ.md) – Section 3: Architecture & Scalability
- [`Tradeoffs.md`](../Tradeoffs.md) – Retry + DLQ pattern for resilience
- [`ArchitectureStyle.md`](../ArchitectureStyle.md) – Event-driven design and failure isolation


## Consequences

- Introduces additional infrastructure and monitoring responsibility.
- DLQ replay tooling must be built and access-controlled.
- Operators need clear workflows to triage and decide which messages to replay or discard.
- Some business flows (e.g., scheduling) may pause if DLQ thresholds are breached.



## Alternatives Considered

- **Fail silently and log errors only**  
  ✘ Rejected due to risk of data loss and lack of visibility.

- **Rely only on retries with no DLQ**  
  ✘ Rejected as retries alone are insufficient for handling persistent or logical errors.

- **Retry indefinitely**  
  ✘ Rejected to avoid infinite loops, resource waste, and downstream overload.



- Option 1: ...
- Option 2: ...

## Related Docs
- TODO: Link to related ADRs or architectural docs
