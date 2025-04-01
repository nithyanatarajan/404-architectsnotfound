# ADR-007: 009 Service Mesh Consul Envoy

## Status
Accepted

## Context

Inter-service communication requires:

- Load balancing
- Retry logic
- mTLS security
- Traffic observability

We needed a solution that didn't require app-level logic or custom libraries.



## Decision

We adopted:

- **Consul** for service discovery and mesh config
- **Envoy** as a sidecar proxy for traffic routing, retry, and telemetry



## Consequences

- ✅ Uniform observability and security
- ✅ Fine-grained traffic control (timeouts, retries, etc.)
- ⚠️ More infra setup per pod (sidecars)
- ⚠️ Consul agents need HA management



## Alternatives Considered

- Linkerd: Lighter but less flexible
- Istio: Powerful but too heavy for our current scale

## Related Docs

- [`DeploymentStrategy.md`](../DeploymentStrategy.md)


- Option 1: ...
- Option 2: ...

## Related Docs
- TODO: Link to related ADRs or architectural docs
