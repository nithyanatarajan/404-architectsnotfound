# 🧰 Tech Stack – RecruitX Next

This document outlines the tools, frameworks, and platforms chosen for RecruitX Next — along with justification and
evaluation criteria.

---

## 🏗️ Application Architecture

| Component            | Tool / Tech                      | Reason for Choice                                                              |
|----------------------|----------------------------------|--------------------------------------------------------------------------------|
| Microservice Runtime | **Go** and **Python**            | Polyglot architecture: each service uses the language best suited for its task |
| UI Framework         | **Flutter** with **FlutterFlow** | Cross-platform, performant frontend for the recruiter dashboard                |
| API Gateway          | **Kong**                         | Plugin ecosystem, OIDC support, rate limiting, extensible authN control        |
| AuthN & AuthZ        | **OIDC + OPA**                   | Standard identity and policy enforcement mechanisms                            |
| Pub/Sub Messaging    | **Kafka**                        | Durable, scalable async messaging backbone                                     |
| Service Mesh         | **Consul + Envoy**               | Sidecar-based mTLS, traffic routing, discovery, observability integration      |
| Service Discovery    | **Consul**                       | Native K8s + multi-platform support                                            |

---

## 📦 Infrastructure & DevOps

| Component         | Tool / Tech                    | Reason for Choice                                               |
|-------------------|--------------------------------|-----------------------------------------------------------------|
| Container Runtime | **Docker**                     | Ubiquitous, consistent builds                                   |
| Orchestration     | **Kubernetes** (k3s for local) | Industry standard, scalable, local-friendly with `k3s`          |
| Deployment Mgmt   | **Helm**                       | Templated Kubernetes deployments                                |
| IaC               | **Terraform**                  | Declarative, cloud-agnostic infra provisioning                  |
| GitOps            | **ArgoCD**                     | Declarative delivery, drift detection, and pipeline integration |
| CI Tools          | **GitHub Actions / GitLab CI** | Linting, testing, image scan before delivery                    |
| Local Dev         | **k3s**                        | Lightweight Kubernetes setup for fast local development         |

---

## 📊 Observability & Monitoring

| Component  | Tool / Tech                | Reason for Choice                                    |
|------------|----------------------------|------------------------------------------------------|
| Metrics    | **Prometheus**             | K8s-native monitoring and alerting                   |
| Dashboards | **Grafana**                | Rich visualizations for metrics, logs, and traces    |
| Logs       | **Loki**                   | Lightweight log aggregation, integrated with Grafana |
| Tracing    | **OpenTelemetry + Jaeger** | Distributed tracing with industry standard support   |

---

## 🔐 Security

| Component    | Tool / Tech        | Reason for Choice                                           |
|--------------|--------------------|-------------------------------------------------------------|
| AuthN        | **OIDC**           | Centralized login via Kong Gateway                          |
| AuthZ        | **OPA**            | Fine-grained RBAC via policy as code                        |
| Secrets      | **Vault**          | Secure secrets management integrated with K8s and Consul    |
| Scanning     | **Trivy**          | Shift-left image vulnerability detection                    |
| mTLS + Trust | **Consul + Envoy** | Encrypted service-to-service traffic with sidecar injection |

---

## 🧪 Evaluation Criteria

Each technology was evaluated based on:

- ✅ Open Source & Active Community
- ✅ Kubernetes & Cloud Native compatibility
- ✅ Production Readiness & Observability support
- ✅ Security features (OIDC, mTLS, RBAC, secrets)

---

✅ *This tech stack is cloud-agnostic, secure, and optimized for velocity, observability, and future evolution.*

