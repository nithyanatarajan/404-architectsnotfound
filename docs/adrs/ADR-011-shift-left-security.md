# ADR-011: Shift-Left Security Practices

## Status

Accepted

## Context

Security must be embedded **early in the development lifecycle**, not as a post-deployment step. We needed a
developer-friendly approach that secures:

- Container images
- Secrets and tokens
- API access and authorization
- Internal service communication

## Decision

We adopted the following shift-left security practices:

- **Vault** for secure secrets management and token rotation
- **Trivy** to scan container images during CI for vulnerabilities
- **OPA (Open Policy Agent)** for RBAC, integrated with Kong after OIDC-based authentication
- **TLS & mTLS** enforced between internal services using **Envoy** (part of the Consul service mesh)

## Consequences

- ✅ Early detection of vulnerabilities before runtime
- ✅ Secure secrets injection and lifecycle rotation
- ✅ Fine-grained access control at the API gateway level
- ⚠️ Requires disciplined management of secrets, policies, and TLS certificates

## Alternatives Considered

- **Static secrets in ENV or Kubernetes Secrets**  
  ✘ Rejected due to lack of rotation, auditability, and encryption-at-rest

- **Post-deployment scanning only**  
  ✘ Rejected as it increases exposure window and delays remediation

## Related Docs

- [`DeploymentStrategy.md`](../DeploymentStrategy.md)
- [`Techstack.md`](../Techstack.md)
- [`ADR-003-tech-stack-choice.md`](./ADR-003-tech-stack-choice.md)
