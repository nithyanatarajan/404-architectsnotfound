# ADR-012: NLP-based Chatbot Interface

## Status

Accepted

## Context

RecruitX includes a recruiter-facing chatbot integrated into Messenger, designed to simplify workflows such as
interview scheduling, availability queries, and rescheduling through natural language. Originally scoped for read-only
queries, the chatbot has evolved to support **action-triggering commands** and **fallback-aware notifications**.

## Decision

| Aspect                         | Decision                                                                                                                                               |
|--------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Scope of Interaction**       | Chatbot supports **both informational and action commands**, including slot queries, scheduling, rescheduling, and reporting summaries.                |
| **Integration Environment**    | Deployed as a **Messenger Bot** within MindCompute's workspace; interactions are grouped using threads or pinned cards.                                 |
| **Backend Behavior**           | The chatbot interacts only with the **MongoDB sync-layer cache** — no live calls to external APIs during runtime.                                      |
| **Sample NLP Capabilities**    | Prompts like: “Who’s available for Python this Friday?”, “Reschedule 3 PM for John”, “Schedule ML interview tomorrow”, “Show React load for next week” |
| **Data Freshness Awareness**   | Bot responses include **last-updated timestamps** from the underlying cache to reflect data staleness, if any.                                         |
| **Resilience During Failures** | If data is unavailable or outdated, chatbot surfaces fallback messages and recruiter alerts (e.g., “Using data synced 2 hours ago”).                   |
| **Security and Access**        | Bot is authenticated; RBAC policies enforced via OPA control access to sensitive data and fallback commands.                                           |
| **Statelessness**              | The chatbot is **stateless**; conversational continuity is managed via message threads or user metadata.                                               |

## Consequences

- Responses depend on cache freshness and may be slightly stale if refresh fails or is delayed.
- Security and input validation become critical as the bot supports commands beyond passive queries.
- NLP interpreter must evolve to support recruiter phrasing across teams and regions.
- Admins must monitor cache and sync job health to ensure chatbot remains useful and reliable.

## Alternatives Considered

- **Lookup-only chatbot**  
  ✘ Rejected to maximize recruiter productivity and reduce dashboard reliance.

- **Live API lookups for accuracy**  
  ✘ Rejected due to performance, latency, rate limits, and resilience concerns.

## Decision Drivers

- Recruiter productivity and self-service scheduling
- Secure, observable fallback-aware system design
- Scalable NLP interactions with minimal downtime dependency
- Pluggability of LLM/NLP backend (e.g., Gemini, Ollama)

## Related Docs

- [`AITools.md`](../AITools.md)
- [`AssumptionsAndFAQ.md`](../AssumptionsAndFAQ.md) – Section 4
- [`Microservices.md`](../Microservices.md) – Chatbot + Chatbot Interpreter
