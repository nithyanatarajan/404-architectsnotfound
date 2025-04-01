# ADR-003: Tech Stack Choice

## Status

Accepted

## Context

The RecruitX platform is designed to support real-time scheduling, async communication, AI-enhanced workflows, and
secure multi-user access across UI and chatbot interfaces. Choosing the right tech stack is critical to achieving:

- Resilience and scalability under event-driven load
- Observability and debug-ability of async jobs
- Pluggable integration with external systems and AI tools
- Cloud-native operations and GitOps delivery

## Decision

The stack is selected based on the following categories and criteria:

### 🏗 Application Runtime

| Tool       | Justification                                                                         |
|------------|---------------------------------------------------------------------------------------|
| **Go**     | High performance, concurrency-friendly, ideal for event-driven services               |
| **Python** | Used in AI tools and sync-layer utilities where dynamic packages are better supported |

### 💬 Messaging & Orchestration

| Tool           | Justification                                                               |
|----------------|-----------------------------------------------------------------------------|
| **Kafka**      | Native pub/sub for async communication; supports DLQs, replay, and ordering |
| **Kafka DLQs** | Ensures isolation and recovery of failed message flows with alerting        |
| **Helm**       | Standard Kubernetes packaging and deployment                                |
| **ArgoCD**     | GitOps-based delivery with drift detection and rollback support             |
| **Terraform**  | Cloud-agnostic infra provisioning, reusable across environments             |

### ⚡ Data, Config & Cache

| Tool               | Justification                                                                         |
|--------------------|---------------------------------------------------------------------------------------|
| **MongoDB**        | Used as a sync-layer cache with TTL for time-bound slot data and preference freshness |
| **Config-Service** | Provides tunable weights, rules, and scheduling logic; reloadable at runtime          |

### 🔐 Security & Policy

| Tool               | Justification                                            |
|--------------------|----------------------------------------------------------|
| **OIDC**           | Org-integrated authentication using Okta or similar      |
| **OPA**            | Fine-grained RBAC + policy-as-code for access control    |
| **Vault**          | Secure secrets management integrated with Kubernetes     |
| **Trivy**          | CI-integrated image scanning and vulnerability detection |
| **Consul + Envoy** | Internal mesh for service-to-service mTLS and routing    |

### 📊 Observability

| Tool                       | Justification                           |
|----------------------------|-----------------------------------------|
| **Prometheus**             | System metrics and alerts               |
| **Grafana**                | Dashboards and alert routing            |
| **Loki**                   | Log aggregation integrated with Grafana |
| **OpenTelemetry + Jaeger** | Tracing across async workflows and APIs |

### 🤖 AI & NLP Tools

| Tool / Layer            | Justification                                                   |
|-------------------------|-----------------------------------------------------------------|
| **spaCy, Transformers** | NLP-based intent extraction from recruiter queries              |
| **Gemini (via API)**    | Pluggable cloud-hosted LLM for summarization and chat workflows |
| **Ollama**              | Lightweight local fallback for LLM features                     |
| **Agno**                | Optional agentic automation for DLQ, config ops                 |
| **LangChain**           | Exploratory prompt workflow orchestration                       |

## Evaluation Criteria

| Criteria                 | Applied To                              |
|--------------------------|-----------------------------------------|
| Open Source              | All tools are community-supported       |
| Cloud Native             | K8s-compatible, autoscalable            |
| GitOps Friendly          | Declarative config & deployment support |
| Observability Support    | Tracing, metrics, logs integrated       |
| Security & Trust         | OIDC, mTLS, RBAC, Secrets integrated    |
| Performance & Resilience | DLQ, retries, cache-first reads         |
| Extensibility & AI Ready | NLP/LLM abstracted for future models    |

## Consequences

- All services follow a **cache-as-primary, event-driven** design
- Failures are isolated and retried via Kafka DLQ setup
- AI features augment the experience but are non-blocking
- The stack ensures portability, traceability, and low coupling
- If the **NEO platform** is adopted internally, deployment tooling may be streamlined further

## Alternatives Considered

- Monostack in Go or Python only
- Traditional CI/CD (e.g., Jenkins-based pipelines)
- Static or server-rendered UI instead of Flutter-based dashboard

## Related Docs

- [`Techstack.md`](../Techstack.md)
- [`ADR-002-architecture-approach.md`](./ADR-002-architecture-approach.md)
