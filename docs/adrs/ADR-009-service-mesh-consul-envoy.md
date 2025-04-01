# ADR-009: Service Mesh with Consul + Envoy

## Status

Accepted

## Context

Inter-service communication within RecruitX must support:

- **Load balancing** between replicas
- **Retry logic** for transient failures
- **mTLS encryption** to secure internal traffic
- **Traffic observability** to trace failures and latencies

These features must be implemented **without embedding logic** inside each microservice.

## Decision

We adopted a **service mesh** pattern using:

- **Consul** for service discovery, health checking, and mesh configuration
- **Envoy** sidecar proxies for:
    - mTLS enforcement
    - Retry/backoff logic
    - Request-level metrics and distributed tracing

This allows secure, observable service-to-service communication across Kubernetes pods with minimal developer effort.

## Consequences

- ✅ Uniform security (mTLS) and observability across all services
- ✅ Built-in circuit breaking, retries, timeouts via Envoy
- ✅ Consul provides first-class support for multi-platform discovery
- ⚠️ Requires additional sidecar containers per pod (increased resource usage)
- ⚠️ Consul cluster and agents need to be highly available and observable
- ⚠️ Learning curve for fine-tuning mesh policies and Envoy configuration

## Alternatives Considered

- **Linkerd**: Simpler and lighter, but less flexible and mature for policy enforcement.
- **Istio**: Feature-rich but complex; considered overkill for our scale and current needs.

## Related Docs

- [`DeploymentStrategy.md`](../DeploymentStrategy.md)
- [`ArchitectureStyle.md`](../ArchitectureStyle.md) – Secure Internal Mesh
