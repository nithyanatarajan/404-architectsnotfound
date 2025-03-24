# 🧱 Architectural Characteristics & Design Overview

This section outlines the core architectural principles, security strategy, deployment patterns, and integration
considerations for the RecruitX Next platform.

---

## ⚙️ Architecture Style

- **Type**: Event-Driven Microservices
- **Pattern**: Publish/Subscribe (event bus) + REST for critical flows
- **Principles**:
    - Each service owns its **data** and **cache**
    - Loose coupling through events
    - Stateless wherever possible
    - Horizontal scalability and cloud-native deployability

---

## 📐 Core Architectural Characteristics

| Characteristic    | Design Strategy                                                    |
|-------------------|--------------------------------------------------------------------|
| **Scalability**   | Stateless microservices, horizontal autoscaling, cache per service |
| **Availability**  | Retry queues, fallback flows, calendar watcher renewal             |
| **Resilience**    | Circuit breakers, DLQs, watchdogs, redundant integrations          |
| **Performance**   | Local service caches, async background jobs, optimized querying    |
| **Security**      | SSO (Okta), RBAC, JWT tokens, signed event payloads                |
| **Observability** | Structured logs, traces, metrics, alerting                         |
| **Extensibility** | Config-driven matchers, pluggable scoring logic                    |
| **Deployability** | Dockerized, CI/CD pipelines, blue-green or canary releases         |
| **Portability**   | Kubernetes-native, infrastructure-as-code (e.g., Terraform)        |

---

## 🔐 Authentication & Authorization

| Area               | Strategy                                                         |
|--------------------|------------------------------------------------------------------|
| **Authentication** | Single Sign-On (SSO) using Okta + OIDC                           |
| **Authorization**  | Role-Based Access Control (RBAC) at API Gateway or service level |
| **Token Model**    | JWT tokens with scopes and role claims                           |
| **API Security**   | Gateway-level rate limiting, request signing, TLS everywhere     |

### RBAC Roles

| Role         | Capabilities                                    |
|--------------|-------------------------------------------------|
| Recruiter    | Initiate, view, and manage interviews           |
| Interviewer  | View personal interview info, RSVP via calendar |
| Admin        | Access configs, manage override rules           |
| Service Bots | Narrow scoped system actions                    |

---

## 🚀 Deployment Strategy

| Area                 | Strategy                                             |
|----------------------|------------------------------------------------------|
| **Containerization** | Docker images per service                            |
| **Orchestration**    | Kubernetes (GKE/EKS/AKS)                             |
| **CI/CD**            | GitHub Actions or GitLab CI/CD                       |
| **Release Model**    | Canary or Blue/Green for sensitive services          |
| **Scaling**          | HPA (Horizontal Pod Autoscaler) using custom metrics |
| **Config Mgmt**      | ConfigMaps, Secrets, and centralized config service  |

---

## 🔗 Integration Considerations

| System          | Integration Mode | Resilience Patterns                    |
|-----------------|------------------|----------------------------------------|
| InterviewLogger      | REST API         | Retry with backoff, API quota handling |
| MindComputeScheduler        | Webhooks + REST  | Webhook retries, fallback polling      |
| MyMindComputeProfile          | REST Pull        | Sync jobs, fallback cache              |
| Calendar | API + Webhooks   | Watcher renewal, RSVP status parsing   |
| LeavePlanner   | REST API         | Periodic availability sync             |

---

## 📈 Observability

| Capability       | Tool                                             |
|------------------|--------------------------------------------------|
| **Logging**      | JSON structured logs, shipped to ELK or GCP Logs |
| **Tracing**      | OpenTelemetry + Jaeger                           |
| **Metrics**      | Prometheus + Grafana                             |
| **Alerting**     | Threshold-based + anomaly detection              |
| **Audit Trails** | Central event logging per domain entity          |

---

## 🧪 Testing Strategy

| Test Type         | Coverage                                     |
|-------------------|----------------------------------------------|
| Unit Tests        | Core logic & scoring algorithms              |
| Contract Tests    | Between services, matcher vs. config, etc.   |
| Integration Tests | End-to-end flows (schedule → match → notify) |
| Load Tests        | Interviewer selection under scale            |
| Chaos Tests       | Watcher failures, queue lags, rate limits    |

---

## 🗃️ Data Ownership & Schema Versioning

- Every service owns its own **data model** and **storage**
- Events are versioned and emitted with schema metadata
- Central schema registry (e.g., AsyncAPI or Kafka schema registry) ensures compatibility

---

## 🔁 Event Bus & Event Strategy

- **Bus**: Kafka or Google Pub/Sub (TBD by deployment environment)
- **Event Types**:
    - `interviewer_profile.updated`
    - `interviewer_preferences.updated`
    - `availability.checked`
    - `interviewer.match.suggested`
    - `slot.recommendation.generated`
    - `chat.query.asked`
    - `interview.scheduled`, `interview.rescheduled`
    - `report.generated`, `alert.triggered`
- **Events include** metadata, context IDs, correlation IDs

---

