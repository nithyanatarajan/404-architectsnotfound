# ⚙️ Architecture Style – RecruitX Next

## 🔧 Type

**Event-Driven Microservices** architecture powered by asynchronous messaging via Kafka and secure RESTful APIs over an
internal mesh.
All services operate within the company’s trusted network, integrated through secure, observable, and policy-driven
communication.
Topics are configured with retry and DLQ mechanisms to ensure fault tolerance and replayability.
Reads follow a **cache-as-primary** strategy backed by MongoDB with TTL indexing.

## 🧱 Pattern

- **Publish/Subscribe**: Kafka topics for decoupled communication between microservices
- **Request/Response (REST)**: Chatbot and Dashboard interact with internal services via authenticated APIs
- **CQRS-Inspired Read/Write Separation**: Slot reads handled via Slot Seeker and MongoDB; writes via Candidate +
  Interview Scheduler

## 📐 Architectural Principles

| Principle                    | Description                                                                                   |
|------------------------------|-----------------------------------------------------------------------------------------------|
| **Loose Coupling**           | Services communicate asynchronously via events and explicitly defined APIs                    |
| **Single Responsibility**    | Each service is designed around a narrow, domain-aligned concern                              |
| **Statelessness**            | Services are stateless; persistence is handled via MongoDB or external systems                |
| **Cache-as-Primary**         | All reads (slots, preferences, availability) are served from MongoDB with TTL-based freshness |
| **Configuration-Driven**     | Scheduling logic and scoring are fully externalized via the Config Service                    |
| **Fallback-Aware**           | DLQs, retries, alerts, and manual override options are built-in                               |
| **Observability-First**      | Logs, traces, and metrics via OpenTelemetry, Prometheus, Grafana, and Loki                    |
| **Secure-by-Default**        | All internal calls use mTLS, OIDC for authN, and OPA for authZ                                |
| **AI-Augmented**             | NLP-based chatbot and AI-assisted reporting via pluggable LLMs                                |
| **Cloud-Agnostic Readiness** | Works with Terraform, Helm, GitOps — adaptable to NEO or platform-native CI/CD                |

## 🔐 Security Model

- **Authentication**: OIDC via Okta (user and service-level identity)
- **Authorization**: OPA-based RBAC for internal APIs and dashboards
- **Trust Layer**: All service-to-service traffic encrypted via Consul + Envoy (mTLS)
- **Secrets Management**: Vault (or internal equivalent) for secure credential storage
- **Internal Mesh**: No public-facing gateway; all traffic flows within the company network
- **Shift-Left Security**: Trivy and other scanners integrated into CI pipelines
- **PII Handling**: All user data is treated as sensitive and encrypted in transit and at rest

## 🚀 Deployment Strategy

- **Declarative Infrastructure**: Terraform, Helm, and GitOps practices
- **GitOps-First**: ArgoCD auto-syncs service states and detects drift
- **Local Development**: k3s with mock integrations for fast iteration
- **Cloud-Agnostic**: Portable across vendors or internal Kubernetes
- **NEO Assumption**: Deployment tooling may change upon NEO adoption

## 🧩 Supporting Styles & Components

- **Service Mesh**: Envoy sidecars provide secure routing, retries, and observability
- **Event Bus**: Kafka ensures durable pub/sub and DLQ isolation
- **UI Layer**: Flutter dashboard (MVP: read-only) backed by internal APIs
- **Hybrid Interaction**: Supports chatbot automation and UI-based manual fallback
- **Configuration Layer**: Runtime-tunable weights and logic managed via Config Service
- **LLM Layer**: AI features (NLP/chat/reporting) use pluggable LLMs (e.g., Gemini, Ollama)

## ✅ Justification

- Built for real-world recruiter workflows with resilience and fallback in mind
- Aligns with internal-only deployment and secure communication standards
- Combines event-driven design with cache-first reads and AI-driven interfaces
- Offers clear service boundaries, runtime tunability, and open technology choices
- Optimized for observability, security, and future extensibility
