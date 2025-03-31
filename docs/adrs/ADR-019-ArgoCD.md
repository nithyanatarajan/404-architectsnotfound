**ADR: Use ArgoCD for GitOps-Based Continuous Delivery**

**Status:** Accepted  
**Date:** 2025-03-26  
**Author:** Vishwapriyaj

---

### Context
To manage environment consistency and deployment safety, we need a GitOps tool that continuously reconciles infrastructure state from Git with what's deployed in Kubernetes. ArgoCD fits naturally with our Helm + Kubernetes setup.

---

### Alternatives
- Manual `kubectl` deployments
- CI/CD-driven manifests (e.g., Jenkins)
- GitOps tools like ArgoCD or FluxCD

---

### PrOACT
- **Problem:** Configuration drift, lack of traceability and repeatability in deployments
- **Objectives:** Declarative infrastructure delivery, Git as the source of truth, automated drift detection and reconciliation
- **Alternatives:** Manual pipelines, Jenkins, FluxCD, ArgoCD
- **Consequences:** ArgoCD introduces a new tool to manage and integrate with RBAC and clusters
- **Tradeoffs:** Additional tool vs. consistency, safety, and transparency of environments

---

### Decision
Use **ArgoCD** to automate synchronization of Kubernetes manifests from Git repositories. It offers visual feedback, RBAC support, application health monitoring, and rollback features.

---

### Tradeoffs - Mitigations
- **Extra operational layer** → Mitigated by ArgoCD's declarative configuration and easy UI
- **User management and access control** → Integrate with OIDC for centralized auth and RBAC

---

