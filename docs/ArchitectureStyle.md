# ⚙️ Architecture Style – RecruitX Next

## 🔧 Type

**Event-Driven Microservices** architecture, powered by asynchronous messaging with Kafka and critical flows handled via
RESTful APIs.

## 🧱 Pattern

- **Publish/Subscribe** for service-to-service communication using Kafka
- **Request/Response (REST)** for user and chatbot-initiated interactions
- **CQRS-Inspired Read/Write Separation**: Reads via event-driven updates, writes via command APIs

## 📐 Architectural Principles

| Principle                  | Description                                                                                                       |
|----------------------------|-------------------------------------------------------------------------------------------------------------------|
| **Loose Coupling**         | Services communicate via events and defined APIs, allowing independent scaling and deployment                     |
| **Single Responsibility**  | Each service focuses on one domain concern (e.g., candidate handling, scheduling, notifications)                  |
| **Statelessness**          | Stateless service design enables resilience and scalability (except where persistence is needed, e.g., scheduler) |
| **Data Ownership**         | Each service manages its own cache or data access interface, avoiding tight coupling                              |
| **Observability-First**    | Traces, logs, and metrics integrated from day one using OpenTelemetry, Prometheus, and Loki                       |
| **Retry & Fallback Paths** | Errors handled using retries, circuit breakers, and manual overrides (e.g., `ManualActionRequired`)               |
| **Cloud-Native Readiness** | Works seamlessly on Kubernetes using Helm, Terraform, and GitOps with ArgoCD                                      |

## 🔐 Security Model

- **AuthN**: OIDC (e.g., Google) via Kong Gateway
- **AuthZ**: RBAC policies enforced via OPA (Open Policy Agent)
- **Trust Layer**: mTLS between services using Consul + Envoy service mesh
- **Secrets Management**: Vault integration for secure runtime secrets
- **Shift-Left Security**: Trivy and other scanners used in CI/CD pipelines

## 🚀 Deployment Strategy

- **GitOps-first**: ArgoCD manages Helm chart releases and detects drift
- **Cloud-Agnostic**: Terraform used for modular infra provisioning
- **Local Setup**: K3s cluster for lightweight local development
- **DevOps Stack**: CI + CD through ArgoCD and Helm with containerized builds

## 🧩 Supporting Styles & Components

- **Service Mesh**: Envoy sidecars for traffic routing, mTLS, retries, metrics
- **Event Bus**: Kafka enables durable pub/sub across services
- **UI Layer**: Flutter dashboard backed by APIs and event feeds
- **Hybrid Interaction**: Supports both chatbot-based automation and UI-based manual fallback
- **Configuration-Driven Logic**: Weights and rules stored in `config-service` enable runtime tuning

## ✅ Justification

- Built to support a **resilient, asynchronous, and scalable system**
- Handles real-world workflow scenarios with fallback support
- Balances innovation (eventing, tracing) with pragmatic choices (API boundaries, retries)
- Open tooling stack ensures future-proof evolution and easy portability

