# ADR-008: Shift-Left Security Practices

## Status

Accepted

## Context

Security must be embedded early, not retrofitted. We needed a developer-centric approach to secure images, secrets, and
runtime APIs.

## Decision

We adopted:

- **Vault** for secrets and token rotation
- **Trivy** to scan container images in CI
- **OPA** for RBAC, integrated with Kong request pipeline (post-OIDC auth)
- **TLS & mTLS** in internal services via Envoy

## Consequences

- ✅ Reduces risk of vulnerabilities at build and runtime
- ✅ Automates several security best practices
- ⚠️ Requires secret and policy lifecycle management

## Alternatives Considered

- Static secrets in ENV or Kubernetes Secrets
- Post-deploy scanning only

## Related Docs

- [`DeploymentStrategy.md`](../DeploymentStrategy.md)
