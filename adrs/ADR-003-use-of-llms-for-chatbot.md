# ADR-003: Use of LLMs for Chatbot

## Status

Accepted

## Context

Recruiters often face friction in manually searching for interviewers or navigating complex dashboards. Natural Language
Interfaces (NLI) can reduce time and enhance accessibility.

We considered:

- Traditional menu-based chatbots
- Rule-based intent matchers (e.g., Rasa)
- Pre-trained LLMs with prompt chaining
- LangChain + OpenAI-based agentic workflows

## Decision

We will use a **LangChain + OpenAI LLM-based chatbot** embedded in Messenger for recruiters, with features like:

- Interviewer lookup by skill, round, date
- Top-N recommendation
- Natural language queries like "Who's free for a backend interview tomorrow?"
- Optional call-to-actions like "schedule with Ravi at 3 PM"

We’ll also provide API fallback for structured flows.

## Consequences

- ✅ Improves recruiter UX dramatically
- ✅ NLP engine can grow with new use cases
- ⚠️ Requires guardrails, validations, and context windows
- ⚠️ Needs observability into model performance and fallback handling

## Alternatives Considered

- Rule-based bots: simpler, but harder to scale across natural queries
- No chatbot: loss of productivity & modern UX
