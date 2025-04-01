# ADR-005: Cache-as-Primary Read Strategy

## Status

Accepted

## Context

The RecruitX platform integrates with multiple third-party systems (Calendar, MyMindComputeProfile, LeavePlanner, MindComputeScheduler),
each with varying SLAs, reliability, and latency profiles. Direct, real-time reads from these systems introduce risks of
API failure, throttling, and user-visible latency.

To ensure fast, resilient, and consistent user experience, we adopted a **cache-as-primary read pattern** — where all
reads are served from periodically refreshed cache (MongoDB), and no service directly calls external APIs at runtime.

## Decision

| Aspect                  | Decision                                                                                                                                            |
|-------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------|
| **Cache Read Path**     | All reads (chatbot, scheduler, dashboard) are served from MongoDB, refreshed via background jobs. No live external API calls occur at request time. |
| **Write/Sync Path**     | `harvest-sync` periodically pulls data from external systems (Calendar: every 30 min; MyMindComputeProfile/Leave: daily) and writes to MongoDB.                   |
| **Fallbacks**           | On sync failure, system continues using stale data and raises alerts. After 3 failures (configurable), impacted flows may pause.                    |
| **Staleness Awareness** | Records are stored with `last_updated` timestamps. UI components display these for visibility.                                                      |
| **Service Behavior**    | All internal services are decoupled from external systems. They query only the cache (MongoDB) to ensure testability and fault isolation.           |
| **Performance Impact**  | MongoDB provides fast document lookups; all user-facing reads benefit from low latency even under external downtime.                                |
| **Observability**       | All sync jobs emit metrics on freshness, failures, and TTL expiry. Failures are logged and monitored via Prometheus + Grafana.                      |
| **Configuration**       | Sync intervals, TTL values, and retry policies are managed via config and can be updated without redeployment.                                      |

## Consequences

- The system can continue operating (with stale data) when integrations are temporarily unavailable.
- Requires maintenance of refresh job cadence, TTL policies, and failure alerting.
- Services must treat cached data as potentially outdated and defensively handle gaps.
- MongoDB may grow in size unless TTL indexing is carefully enforced.

## Alternatives Considered

- **Live API reads on demand**  
  ✘ Rejected due to third-party latency, quota limits, and risk of blocking user flows.

- **Hybrid mode (cache-first, fallback to live)**  
  ✘ Rejected to avoid inconsistencies and complexity across services.

- **Redis for fast cache**  
  ✘ Removed due to complexity of expiry coordination and operational overhead in refresh tuning.

## Decision Drivers

- Resilience to third-party outages
- Predictable low-latency experience for chatbot and dashboard
- Simplified sync-vs-read separation of concerns
- Clear observability and alerting on data freshness

## Related Docs

- [`AssumptionsAndFAQ.md`](../AssumptionsAndFAQ.md) – Section 2: Integrations & Data Flow
- [`Microservices.md`](../Microservices.md) – `harvest-sync`, cache responsibilities
- [`ArchitectureStyle.md`](../ArchitectureStyle.md) – Read-from-cache-first architecture
- [`Tradeoffs.md`](../Tradeoffs.md) – Availability over strict consistency
