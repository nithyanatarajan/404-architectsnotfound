# ADR-010: 012 Nlp Chatbot

## Status
Accepted

## Context

RecruitX includes a recruiter-facing chatbot integrated into Messenger, intended to simplify key workflows such as
interview scheduling, availability queries, and rescheduling via natural language. Initially conceived as a read-only
informational interface, the chatbot was extended to support **action-triggering commands** and system-driven fallback
notifications.

| **Backend behavior**           | The chatbot interacts only with the **central Redis cache** — no live API calls are made during chatbot sessions.                                                        |
| **Sample NLP capabilities**    | Supports prompts like: “Who’s available for Python this Friday?”, “Reschedule 3 PM for John”, “Schedule an ML interview tomorrow”                                        |
| **Data freshness awareness**   | Bot responses include **last-updated timestamps** (e.g., “based on availability synced 20 min ago”).                                                                     |
| **Resilience during failures** | If underlying data is stale or unavailable, the bot responds with graceful fallbacks and recruiter alerts (e.g., “Data could not be refreshed, fallback results shown”). |
| **Security and access**        | Bot is authenticated; access to sensitive commands and fallback visibility is governed via RBAC.                                                                         |



## Decision

|--------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Scope of interaction**       | The chatbot supports **both queries and actions**, such as scheduling, rescheduling, and retrieving interviewer availability.                                            |

- Recruiter convenience and speed
- Minimizing system dependencies during live use
- NLP extensibility for future flows
- Fast user feedback loop and fallback safety

## Related Docs

- [`AITools.md`](../AITools.md)


## Consequences

- Chatbot responses may reflect slightly stale data depending on cache freshness.
- Recruiters may need to switch to dashboard-based fallback flows in cases of persistent failure.
- NLP command coverage must be tested against realistic recruiter phrasing.
- Action-triggering flows must be secured with strict input validation and auditing.



## Alternatives Considered

- **Read-only chatbot for lookups only**  
  ✘ Rejected to improve recruiter productivity and reduce dashboard dependence.

- **Live API calls for real-time accuracy**  
  ✘ Rejected due to external API latency, rate limits, and unreliability.



- Option 1: ...
- Option 2: ...

## Related Docs
- TODO: Link to related ADRs or architectural docs
