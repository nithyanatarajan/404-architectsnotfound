# ADR-003: 005 Cache As Primary Read

## Status
Accepted

## Context

The RecruitX platform integrates with multiple third-party systems (Calendar, MyMindComputeProfile, LeavePlanner, MindComputeScheduler),
each with varying SLAs and API behaviors. Direct, real-time access to these systems introduces risk due to potential
downtime, latency, or throttling. For performance, resilience, and consistency across services, we adopted a
**cache-as-primary read pattern** — where all reads are served from cached data, and cache freshness is managed
asynchronously.



## Decision

|-------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Cache Read Path**     | All reads (chatbot, scheduler, dashboard) are served from cached data. External API calls are never made at request time.                                   |
| **Write/Sync Path**     | Background refresh jobs or workers pull data from external systems and update the cache on a schedule (e.g., Calendar: 30 min, MyMindComputeProfile: daily).              |
| **Fallbacks**           | If a refresh fails, the system serves **last known data** from cache and alerts the recruiter. After 3 consecutive failures, the affected flows are paused. |
| **Staleness Awareness** | Cached records include timestamps to indicate freshness. UIs (chatbot, dashboard) display these transparently.                                              |
| **Service Behavior**    | All consumer services (chatbot, scheduler, matching engine) are **decoupled from external APIs**, improving testability and uptime.                         |
| **Performance Impact**  | Fast lookup from cache reduces latency and protects the system from external dependency slowness.                                                           |
| **Observability**       | Cache sync status, TTLs, and failures are monitored and surfaced via internal dashboards.                                                                   |
| **Configuration**       | Cache refresh intervals, TTLs, and retry thresholds are configurable per data source.                                                                       |


- Reliability under partial failure of external systems
- Performance for chatbot and scheduling flows
- Predictable, low-latency UX
- Clean separation of sync logic from core business logic
- Simplified integration testing

## Related Docs

- [`AssumptionsAndFAQ.md`](../AssumptionsAndFAQ.md) – Section 2: Integrations & Data Flow
- [`Microservices.md`](../Microservices.md) – InterviewerAvailabilityService, CacheRefreshJob
- [`ArchitectureStyle.md`](../ArchitectureStyle.md) – Read-from-cache-first architecture
- [`Tradeoffs.md`](../Tradeoffs.md) – Availability over consistency


## Consequences

- System can operate in degraded mode with stale data if external APIs are unavailable.
- Requires observability for staleness, alerting, and sync job failures.
- Introduces slight complexity in maintaining sync jobs and cache TTL policies.
- All logic must defensively handle possibly outdated or incomplete data.



## Alternatives Considered

- **Live API reads on demand**  
  ✘ Rejected due to latency, rate-limiting, and reliability issues from 3rd-party systems.

- **Hybrid mode (cache first, fallback to API)**  
  ✘ Rejected for simplicity and consistency. This would introduce inconsistent behavior between components.

- **Materialized views in database**  
  ✘ Rejected for lack of flexibility and decoupling. Redis is better suited for fast lookup and TTL.



- Option 1: ...
- Option 2: ...

## Related Docs
- TODO: Link to related ADRs or architectural docs
