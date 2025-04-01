# ADR-008: 010 Gitops Argocd

## Status
Accepted

## Context

We need a reproducible, auditable, and automated way to manage deployments across dev, staging, and prod environments.
Traditional CI/CD tools (like GoCD or Jenkins) require manual promotion logic and lack drift detection.

GitOps offers:

- Git as the single source of truth
- Declarative infrastructure and application state
- Automatic reconciliation between Git and cluster



## Decision

We chose **ArgoCD** as our GitOps tool to manage Kubernetes deployments. Key practices:

- **Helm charts** are stored and versioned in Git
- **Environment-specific values.yaml** are generated or maintained per environment (e.g., dev, staging, prod)
- ArgoCD watches Git and syncs to the target cluster accordingly
- **GitHub Actions** or **GitLab CI** handles image builds, testing, vulnerability scanning, and image pushes

CI pipelines are responsible for:

1. Building the service and container image
2. Tagging and pushing the image to the container registry
3. Updating the Helm `values.yaml` or Kustomize overlays in Git with the new image tag
4. Committing the change to Git (which ArgoCD then picks up and applies)



## Consequences

- ✅ Clear separation between **build (CI)** and **deploy (ArgoCD)**
- ✅ Git history becomes the audit log of deployments
- ✅ Supports preview environments and rollout strategies (e.g., blue-green, canary)
- ⚠️ Requires good Git hygiene and values templating discipline
- ⚠️ Developers must understand GitOps flow for troubleshooting



## Alternatives Considered

- **GoCD or Jenkins**: Imperative, state-less, and harder to trace
- **Helm CLI / kubectl apply**: Manual, not auditable, no drift detection

## Related Docs

- [`DeploymentStrategy.md`](../DeploymentStrategy.md)
- [`Techstack.md`](../Techstack.md)
- [`ADR-003-tech-stack-choice.md`](./ADR-003-tech-stack-choice.md)


- Option 1: ...
- Option 2: ...

## Related Docs
- TODO: Link to related ADRs or architectural docs
