# ADR-003: Tech Stack Choice

## Status

Accepted

## Context

The tech stack needed to be cloud-agnostic, scalable, event-driven, and developer-friendly — while supporting
automation, AI, and observability.

## Decision

We selected the following key tools:

| Layer          | Technology                                       | Justification                                         |
|----------------|--------------------------------------------------|-------------------------------------------------------|
| Languages      | Go, Python                                       | Performance + NLP and data processing                 |
| Messaging      | Kafka                                            | Event orchestration                                   |
| Gateway        | Kong + OIDC + OPA                                | AuthN/AuthZ and RBAC                                  |
| UI             | Flutter + FlutterFlow                            | Visual-first UI with code fallback when needed        |
| Config & Cache | Mongo, Redis                                     | Dynamic scheduling + high-speed slot lookup           |
| Infra          | Kubernetes + Helm + Terraform                    | Cloud-native deployments                              |
| GitOps         | ArgoCD                                           | Declarative, drift-free environments                  |
| Observability  | OpenTelemetry, Prometheus, Grafana, Loki, Jaeger | End-to-end tracing, metrics, logs with open standards |
| Security       | Vault, Trivy                                     | Secret mgmt, container scans                          |

## Consequences

- ✅ Dev teams can build quickly using the right tool per use case
- ✅ Foundation for future automation and agent integration
- ⚠️ Slight increase in toolchain complexity and onboarding needs

## Alternatives Considered

- Monostack in Go or Python only
- Traditional CI/CD (Jenkins, GoCD)
- Manual UI in raw Flutter

## Related Docs

- [`Techstack.md`](../Techstack.md)
- [`ADR-002-architecture-approach.md`](./ADR-002-architecture-approach.md)
