# ADR-007: External Integration Assumptions and Risks

## Status

Accepted

## Context

RecruitX integrates with several external systems (e.g., Calendar, MindComputeScheduler, MyMindComputeProfile, LeavePlanner) to retrieve
interviewer availability, capacity, preferences, and leave information. However, the access methods and contract
guarantees across these systems vary significantly.

Some systems are behind SSO, others have undocumented APIs, and webhook support is absent across the board. To proceed
with development and maintain a resilient system, we are documenting the **assumptions, access models, and risks**
associated with each integration.

## Decision

| Integration            | Assumptions, Constraints, and Risks                                                                                                                                                           |
|------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Calendar**    | Accessed via **API behind MindCompute's Okta SSO**, using **OIDC/OAuth2**. Service accounts and tokens must be securely managed. Failure to authenticate will trigger fallback logic.            |
| **MyMindComputeProfile**             | Assumed to expose APIs for fetching skills, preferences, and rounds. No documentation or sandbox was confirmed at design time. Fallbacks rely on cache freshness + alerts.                    |
| **MindComputeScheduler**           | High-risk dependency. Assumes APIs for interviewer load and capacity exist, but **no formal contract or confirmation is available**. Integration plan is based on expectation, not guarantee. |
| **LeavePlanner**      | Expected to expose API to check leave status per interviewer. Data is refreshed daily. Polling assumed, no webhook support.                                                                   |
| **Webhooks**           | No external systems are expected to push updates. All integrations are built using **scheduled polling** via background jobs.                                                                 |
| **Rate Limits & Auth** | External rate limits and token expiry are not explicitly documented. Refresh jobs are designed with **configurable backoff and retry thresholds** to avoid lockout.                           |

## Consequences

- If APIs are not provided as expected (e.g., MindComputeScheduler), development timelines may be impacted.
- The system must degrade gracefully by falling back to stale cached data and alerting recruiters.
- Any change in auth flows (e.g., Okta tokens) will require secure reconfiguration.
- Refresh jobs, DLQs, and alerting become critical components of integration health.

## Alternatives Considered

- **Wait for finalized contracts before design**  
  ✘ Rejected due to project timelines and need for iterative delivery.

- **Scrape UIs or build internal sync hacks**  
  ✘ Rejected due to poor maintainability and high risk.

- **Integrate only after pilot phase**  
  ✘ Deferred for future iterations; core design assumes best-effort integrations now.

## Decision Drivers

- Need for velocity despite uncertain API guarantees
- Building a resilient platform with observable degradation paths
- Clarity on fallback strategies tied to cache and DLQs
- Shared understanding across teams about integration readiness

## Related Docs

- [`AssumptionsAndFAQ.md`](../AssumptionsAndFAQ.md) – Section 2: Integrations
- [`ArchitectureStyle.md`](../ArchitectureStyle.md) – External system polling and refresh patterns
- [`Tradeoffs.md`](../Tradeoffs.md) – Availability > consistency, fallback-first design
