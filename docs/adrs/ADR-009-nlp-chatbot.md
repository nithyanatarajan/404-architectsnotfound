# ADR-009: AI/NLP-based Chatbot Interface

## Status

Accepted

## Context

Recruiters prefer natural interactions when scheduling interviews. Slash commands and buttons feel rigid.

## Decision

We added an **NLP interpreter** to understand recruiter messages and map to intents like:

- Schedule interview
- Reschedule
- Check status

Fallback flows redirect to the dashboard if input is unrecognized.

## Consequences

- ✅ More intuitive and conversational flow
- ✅ Easy to expand with new intents
- ⚠️ Requires testing and fallback coverage

## Alternatives Considered

- Command-only chatbot
- Static button flows

## Related Docs

- [`AITools.md`](../AITools.md)
