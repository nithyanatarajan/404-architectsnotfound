# ⚙️ Architecture Style – RecruitX Next

## 🔧 Type

**Event-Driven Microservices** architecture, powered by asynchronous messaging with Kafka and critical flows handled via
RESTful APIs. Topics are configured with retry and DLQ mechanisms to ensure fault tolerance and replayability of failed
workflows. Reads are served exclusively via a cache-as-primary strategy.

## 🧱 Pattern

- **Publish/Subscribe** for service-to-service communication using Kafka
- **Request/Response (REST)** for user and chatbot-initiated interactions
- **CQRS-Inspired Read/Write Separation**:
    - Writes via command APIs or background sync jobs
    - Reads strictly via Redis-based cache (no live API dependency)

## 📐 Architectural Principles

| Principle                  | Description                                                                                                       |
|----------------------------|-------------------------------------------------------------------------------------------------------------------|
| **Loose Coupling**         | Services communicate via events and defined APIs, allowing independent scaling and deployment                     |
| **Single Responsibility**  | Each service focuses on one domain concern (e.g., candidate handling, scheduling, notifications)                  |
| **Statelessness**          | Stateless service design enables resilience and scalability (except where persistence is needed, e.g., scheduler) |
| **Data Ownership**         | Each service manages its own cache or data access interface, avoiding tight coupling                              |
| **Cache-as-Primary Reads** | All read flows (chatbot, scheduler, dashboard) use Redis; external systems are polled only by refresh jobs        |
| **Retry & Fallback Paths** | Errors handled using retries, circuit breakers, and DLQs; fallback paths include recruiter alerts and dashboard   |
| **Observability-First**    | Traces, logs, and metrics integrated from day one using OpenTelemetry, Prometheus, and Loki                       |
| **Cloud-Native Readiness** | Works seamlessly on Kubernetes using Helm, Terraform, and GitOps with ArgoCD                                      |

## 🔐 Security Model

- **AuthN**: OIDC (e.g., Google) via Kong Gateway
- **AuthZ**: RBAC policies enforced via OPA (Open Policy Agent)
- **Trust Layer**: mTLS between services using Consul + Envoy service mesh
- **Secrets Management**: Vault integration for secure runtime secrets
- **Shift-Left Security**: Trivy and other scanners used in CI/CD pipelines
- **PII Handling**: All user data is treated as sensitive and encrypted at rest and in transit

## 🚀 Deployment Strategy

- **GitOps-first**: ArgoCD manages Helm chart releases and detects drift
- **Cloud-Agnostic**: Terraform used for modular infra provisioning
- **Local Setup**: K3s cluster for lightweight local development
- **DevOps Stack**: CI + CD through ArgoCD and Helm with containerized builds

## 🧩 Supporting Styles & Components

- **Service Mesh**: Envoy sidecars for traffic routing, mTLS, retries, metrics
- **Event Bus**: Kafka enables durable pub/sub across services with DLQ isolation
- **UI Layer**: Flutter dashboard backed by APIs and event feeds
- **Hybrid Interaction**: Supports both chatbot-based automation and UI-based manual fallback
- **Configuration-Driven Logic**: Weights and rules stored in `config-service` enable runtime tuning
- **LLM Layer**: AI features (NLP chatbot, reporting summaries) use pluggable LLMs like Gemini or Ollama; no provider
  lock-in

## ✅ Justification

- Built to support a **resilient, asynchronous, and scalable system**
- Handles real-world workflow scenarios with fallback support
- Balances innovation (eventing, tracing) with pragmatic choices (API boundaries, retries)
- Open tooling stack ensures future-proof evolution and easy portability
- Designed for visibility, resilience, and AI augmentation without tight coupling
