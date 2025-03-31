# ADR-010: Manual Dashboard for Fallback

## Status

Accepted

## Context

While the RecruitX system is primarily automated, real-world scheduling workflows often encounter edge cases such as:

- Interviewer declines close to the scheduled time
- Calendar provider failures or sync delays
- Multiple conflicting constraints (skills, time zones, leaves)
- Situations where no valid slot is found automatically

In such cases, recruiters must be able to manually view, intervene, or override system decisions.

## Decision

We introduced a **manual override dashboard** built using **Flutter with FlutterFlow** to support:

- Viewing candidate and interview details
- Detecting and responding to RSVP status changes
- Manually selecting alternate time slots or interviewers
- Triggering fallback or conflict-resolution flows

The dashboard acts as a reactive **event consumer** and is integrated with internal services for real-time updates.

## Consequences

- ✅ Empowers recruiters to retain control in edge cases
- ✅ Provides observability into system status and fallbacks
- ✅ Avoids black-box automation failures
- ⚠️ Needs strict RBAC, audit logging, and alerting integration
- ⚠️ Some duplication of logic with chatbot flows is acceptable for resilience

## Alternatives Considered

- **Chatbot-only interface**: Not sufficient for exception-heavy scenarios
- **Ops team intervention**: Slow and unscalable

## Related Docs

- [`Microservices.md`](../Microservices.md)
- [`Characteristics.md`](../Characteristics.md)
- [`Techstack.md`](../Techstack.md)
