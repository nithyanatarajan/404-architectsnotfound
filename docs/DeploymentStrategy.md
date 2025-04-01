# 🚀 Deployment Strategy – RecruitX Next

This document outlines how RecruitX Next will be deployed, managed, and scaled in a cloud-agnostic and production-ready
way.

---

## ☁️ Cloud-Agnostic Deployment

RecruitX Next is designed to run on any CNCF-compliant Kubernetes cluster using open tooling:

- ✅ No dependency on AWS, GCP, Azure specifics
- ✅ All provisioning and releases are **declarative**
- ✅ Easily portable between cloud, on-prem, and local setups

> ℹ️ **Note**: If deployed using MindCompute’s internal platform (NEO), some infra and release tools may be replaced with
> approved equivalents. All infra logic is modular and swappable.

---

## 🧰 Tooling Stack

| Layer              | Tool                   | Purpose                                               |
|--------------------|------------------------|-------------------------------------------------------|
| Infrastructure     | Terraform              | Cloud-agnostic infra provisioning                     |
| Container Runtime  | Docker                 | Packaging microservices                               |
| Orchestration      | Kubernetes             | Core runtime environment                              |
| Local Dev          | k3s                    | Lightweight K8s cluster for developers                |
| Package Mgmt       | Helm                   | Templated deployments                                 |
| GitOps Engine      | ArgoCD                 | Automated and secure release delivery                 |
| Service Mesh       | Consul + Envoy         | Sidecar-based discovery, mTLS, retries                |
| Secrets Management | Vault                  | Encrypted credentials, API tokens                     |
| CI / Scan / Secure | GitHub Actions + Trivy | CI pipelines, shift-left security (image scans, etc.) |

---

## 🧪 Environment Topologies

| Environment | Notes                                                            |
|-------------|------------------------------------------------------------------|
| **Local**   | Uses `k3s`, mock integrations, optional Kafka/UI tracing enabled |
| **Dev**     | Full stack with limited resource scaling, GitOps-driven          |
| **Staging** | Canary + tracing enabled, used for performance tests             |
| **Prod**    | Highly available with auto-recovery, full observability stack    |

---

## 🔐 Security-by-Design

- All services are deployed within a **secure internal mesh**
- **OIDC via Okta** is used for service and user identity
- **OPA** policies enforce role-based access at service and API layer
- **mTLS** between services via Consul + Envoy sidecars
- **Vault** handles secrets, access tokens, and sensitive configs
- **Trivy** baked into CI to block vulnerable images pre-deploy

---

## 📈 Observability Stack

- **Prometheus**: metrics
- **Grafana**: dashboards
- **Loki**: logs
- **Jaeger + OpenTelemetry**: traces

All components are pre-wired via Helm/ArgoCD for unified monitoring.

---

## ✅ Best Practices Followed

- GitOps-first for all cluster changes
- Helm-based config versioning
- Service-to-service mTLS inside internal mesh
- Stateless service design where applicable
- Feature flags + config rules externalized to `config-service`
- MongoDB with TTL used for cache, reducing runtime API fetches

---

RecruitX Next’s deployment stack ensures **portability, traceability, resilience**, and **developer velocity** from
local to production.