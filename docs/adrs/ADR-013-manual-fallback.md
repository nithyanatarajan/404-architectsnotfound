# ADR-013: Manual Fallback via Chatbot and Dashboard

## Status

Accepted

## Context

While RecruitX automates most interview scheduling flows, real-world edge cases still occur, such as:

- Interviewer declines or conflicts
- Calendar sync failures or stale availability
- No valid match due to rules or capacity limits

To maintain control and system trust, recruiters need a way to **manually intervene or trigger fallback paths** when
automation doesn’t succeed.

## Decision

We support manual fallback using two interfaces:

### ✅ **Chatbot Fallback Actions (MVP)**

The chatbot supports:

- Triggering reschedules or reassignments via natural language
- Responding with next best slot options if system failed to auto-schedule
- Exposing error context (e.g., "data stale", "calendar sync failed")
- Providing last-updated timestamps and prompting recruiter decisions

This interaction is:

- **Stateless**, conversational, and works via Messenger
- Backed by NLP interpreter + cache-first queries
- Integrated with `interview-scheduler` for retry/override flows

### ⏳ **Dashboard View-Only (MVP)**

- The dashboard in MVP is **read-only** — recruiters can **view context, load, and failure alerts**, but not trigger
  scheduling.
- Used to **observe DLQ entries**, sync status, and interview load.
- Integrated with:
    - `interviewLogger-wrapper` for candidate/job info
    - `notifier-service` for alert views
    - `interview-scheduler` (passively reflects state)

Future versions may include active override features via dashboard.

## Consequences

- ✅ Fallback support is operationalized via chatbot, not blocked on UI maturity
- ✅ Dashboard gives visibility but avoids premature control complexity
- ⚠️ Recruiters must rely on chatbot for all write-path interventions in MVP
- ⏳ Role-based control and audit logging will be required as features expand

## Alternatives Considered

- **UI-based scheduling override in MVP**  
  ✘ Deferred to post-MVP to simplify scope and UX maturity

- **Chatbot-only fallback without dashboard visibility**  
  ✘ Rejected — visibility into sync, DLQ, and candidate load is critical

## Related Docs

- [`Microservices.md`](../Microservices.md) – `chatbot`, `dashboard-service`
- [`Characteristics.md`](../Characteristics.md) – Observability, Resilience
- [`AssumptionsAndFAQ.md`](../AssumptionsAndFAQ.md) – Section 4: UX Strategy
