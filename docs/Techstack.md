# 🧰 Tech Stack – RecruitX Next

This document outlines the tools, frameworks, and platforms chosen for RecruitX Next — along with justification and
evaluation criteria.

---

## 🏗️ Application Architecture

| Component         | Tool / Tech                              | Purpose                                                         |
|-------------------|------------------------------------------|-----------------------------------------------------------------|
| Backend           | Go and Python                            | Polyglot backend for system services and AI tooling             |
| Frontend          | Flutter with FlutterFlow                 | Cross-platform, performant frontend for the recruiter dashboard |
| API Gateway       | Kong                                     | Routing, OIDC integration, API metering                         |
| AuthN & AuthZ     | OIDC + OPA                               | Authentication and policy-based authorization                   |
| Pub/Sub Messaging | Kafka + DLQs                             | Durable event-driven communication and resilience               |
| Service Mesh      | Consul + Envoy                           | Secure service discovery, retries, and traffic control          |
| Service Discovery | Consul                                   | Native K8s + multi-platform support                             |
| Config & Cache    | Mongo (durable sync), Redis (read cache) | Fast, resilient slot lookup with scheduled background syncs     |

## 🤖 AI & Chatbot Layer

| Component       | Tool / Tech                | Purpose                                              |
|-----------------|----------------------------|------------------------------------------------------|
| NLP Interpreter | spaCy, Transformers        | Intent recognition and entity extraction in chatbot  |
| LLM Integration | Gemini, Ollama (pluggable) | Reporting summaries, fallback responses              |
| Agent Layer     | Agno (optional)            | Automated workflow or config generation (future use) |
| Prompt Workflow | LangChain (exploratory)    | Composable prompt chaining for richer interactions   |

## 📦 Infrastructure & DevOps

| Component         | Tool / Tech                | Purpose                                                         |
|-------------------|----------------------------|-----------------------------------------------------------------|
| Container Runtime | Docker                     | Ubiquitous, consistent builds                                   |
| Orchestration     | Kubernetes (k3s for local) | Production and local deployment                                 |
| Deployment Mgmt   | Helm                       | Application packaging and releases                              |
| IaC               | Terraform                  | Declarative, cloud-agnostic infra provisioning                  |
| GitOps            | ArgoCD                     | Declarative delivery, drift detection, and pipeline integration |
| CI Tools          | GitHub Actions / GitLab CI | Linting, testing, image scan before delivery                    |
| Local Dev         | k3s                        | Lightweight Kubernetes setup for fast local development         |

## 📊 Observability & Monitoring

| Component  | Tool / Tech            | Purpose                      |
|------------|------------------------|------------------------------|
| Metrics    | Prometheus             | System metrics and alerting  |
| Dashboards | Grafana                | Unified visual monitoring    |
| Logs       | Loki                   | Aggregated structured logs   |
| Tracing    | OpenTelemetry + Jaeger | Distributed tracing          |
| Alerting   | Grafana Alerts         | DLQ/cache/job failure alerts |

## 🔐 Security

| Component   | Tool / Tech   | Purpose                                  |
|-------------|---------------|------------------------------------------|
| AuthN       | OIDC          | User authentication via identity token   |
| AuthZ       | OPA           | Policy-based access control              |
| Secrets     | Vault         | Secrets and credentials management       |
| Scanning    | Trivy         | Image scanning in CI pipelines           |
| Trust Layer | Consul, Envoy | mTLS and service-level trust enforcement |

✅ *This tech stack is cloud-agnostic, modular, cache-first, AI-ready platform optimized for scale, resilience, future
evolution and secure delivery.*

