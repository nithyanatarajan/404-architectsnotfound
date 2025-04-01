**ADR: Use Kong + OIDC + OPA for API Gateway and Access Control**

**Status:** Accepted  
**Date:** 2025-03-26  
**Author:** Vishwapriyaj

---

### Context
Our architecture includes multiple microservices that need to be exposed externally via a unified, secure, and flexible API gateway. This gateway must support authentication (AuthN), authorization (AuthZ), rate limiting, observability, and integration with enterprise identity providers.

---

### Alternatives
- NGINX + Custom Auth Middleware
- AWS API Gateway + IAM
- Kong with plugin-based OIDC and OPA integration

---

### PrOACT
- **Problem:** We need centralized and standardized control over access and visibility into microservice traffic
- **Objectives:** Provide secure access, enforce RBAC policies, and simplify routing and monitoring
- **Alternatives:** NGINX reverse proxy, cloud-native gateways, Kong with OIDC and OPA
- **Consequences:** Increases operational complexity and introduces learning curve for Kong and OPA
- **Tradeoffs:** Complexity and setup effort vs. flexible, extensible, and auditable access control

---

### Decision
Use **Kong** as the API Gateway, integrated with **OIDC** for authentication and **OPA** for fine-grained authorization policies. This combination allows us to authenticate users using identity providers and enforce RBAC/ABAC policies consistently.

---

### Tradeoffs - Mitigations
- **Operational Overhead** → Use Helm charts and templates for Kong/OPA provisioning
- **Policy Complexity** → Standardize policy bundles and automate testing/validation
- **Performance Overhead** → Use local OPA policy caching and lightweight JWT validation in Kong

---