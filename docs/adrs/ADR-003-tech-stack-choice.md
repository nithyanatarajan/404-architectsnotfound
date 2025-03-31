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

| Tool       | Justification                                                                             |
|------------|-------------------------------------------------------------------------------------------|
| **Go**     | High performance, concurrency-friendly, ideal for event-driven services                   |
| **Python** | Used in AI agents, NLP, and sync-layer services where dynamic tooling is better supported |

### 💬 Messaging & Orchestration

| Tool           | Justification                                                               |
|----------------|-----------------------------------------------------------------------------|
| **Kafka**      | Native pub/sub for async communication; supports DLQs, replay, and ordering |
| **Kafka DLQs** | Ensures isolation and recovery of failed message flows with alerting        |
| **Helm**       | Standard Kubernetes packaging and deployment                                |
| **ArgoCD**     | GitOps-based delivery with drift detection and rollback support             |
| **Terraform**  | Cloud-agnostic infra provisioning, reusable across environments             |

### ⚡ Data, Caching & Config

| Tool               | Justification                                                          |
|--------------------|------------------------------------------------------------------------|
| **PostgreSQL**     | Used for structured, relational data such as feedback, config rules    |
| **MongoDB**        | Flexible document storage used as a sync-layer cache by `harvest-sync` |
| **Redis**          | Ultra-low-latency read layer; all live reads are cache-first           |
| **Config-Service** | Provides tunable weights, logic, and rules via versioned config files  |

### 🔐 Security & Policy

| Tool               | Justification                                              |
|--------------------|------------------------------------------------------------|
| **OIDC**           | Org-integrated auth using standard protocols               |
| **OPA**            | Fine-grained RBAC + policy-as-code for access control      |
| **Vault**          | Secure secrets management integrated with Kubernetes       |
| **Trivy**          | CI-integrated image scanning and vulnerability detection   |
| **Consul + Envoy** | Service mesh for mTLS, routing, retries, trust enforcement |

### 📊 Observability

| Tool                       | Justification                                       |
|----------------------------|-----------------------------------------------------|
| **Prometheus**             | System metrics, autoscaling input, alert generation |
| **Grafana**                | Unified dashboards for all metrics/logs/traces      |
| **Loki**                   | Log aggregation compatible with Grafana             |
| **OpenTelemetry + Jaeger** | End-to-end request tracing across services          |

### 🤖 AI & NLP Tools

| Tool / Layer            | Justification                                                    |
|-------------------------|------------------------------------------------------------------|
| **spaCy, Transformers** | NLP-based intent extraction from recruiter queries               |
| **Gemini (via API)**    | Enterprise-friendly LLM for summarization and chatbot generation |
| **Ollama**              | Local inference during dev/test or fallback                      |
| **Agno**                | Agentic task chaining or automated retry flows (optional)        |
| **LangChain**           | Experimental prompt chaining for structured LLM interactions     |

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

- All services will be structured around a **cache-first, event-driven pattern**
- Failures are isolated via DLQ with observability hooks
- AI features are **enhancement layers**, not critical-path components
- Platform is resilient, cloud-native, and ready for future modularity

## Alternatives Considered

- Monostack in Go or Python only
- Traditional CI/CD (Jenkins)
- Manual UI in raw Flutter

## Related Docs

- [`Techstack.md`](../Techstack.md)
- [`ADR-002-architecture-approach.md`](./ADR-002-architecture-approach.md)
