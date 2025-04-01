# ADR-010: GitOps with ArgoCD

## Status

Accepted

## Context

We need a **reproducible**, **auditable**, and **automated** mechanism to manage deployments across environments (dev,
staging, prod). Traditional CI/CD tools (e.g., GoCD, Jenkins) often:

- Require imperative, script-based workflows
- Lack drift detection
- Have limited auditability

**GitOps** solves this by:

- Treating Git as the single source of truth
- Using declarative manifests (Helm/Kustomize) for environment state
- Ensuring automatic reconciliation between Git and cluster

## Decision

We selected **ArgoCD** as our GitOps delivery tool. Key components of our approach:

- **Helm charts** are stored and versioned in Git for each microservice
- **Environment-specific values.yaml** files or overlays define config per environment
- **ArgoCD watches the Git repository**, applies changes automatically to target clusters
- **CI pipelines (GitHub Actions / GitLab CI)** handle build, test, scan, and image publish stages

### CI Workflow:

1. Build and tag Docker image
2. Push to container registry
3. Update Helm values with new image tag
4. Commit the change to Git (which ArgoCD detects and applies)

## Consequences

- ✅ Decouples CI (build/test) from CD (deploy)
- ✅ Git history acts as an audit trail for every deployment
- ✅ Enables progressive delivery strategies (e.g., blue-green, canary)
- ⚠️ Requires **strict Git hygiene** and values templating discipline
- ⚠️ Developers must understand the **GitOps model** for troubleshooting and rollback

## Alternatives Considered

- **GoCD or Jenkins**: Imperative pipelines, no declarative state tracking
- **Manual `kubectl` or Helm CLI**: No audit trail, not scalable, no drift detection

## Related Docs

- [`DeploymentStrategy.md`](../DeploymentStrategy.md)
- [`Techstack.md`](../Techstack.md)
- [`ADR-003-tech-stack-choice.md`](./ADR-003-tech-stack-choice.md)
