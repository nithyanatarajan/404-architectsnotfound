**ADR: Use Go and Python as Primary Backend Languages**

**Status:** Accepted  
**Date:** 2025-03-26  
**Author:** Vishwapriyaj

---

### Context
We are building a system that includes high-performance real-time services (e.g., slot matching, Kafka consumers) and data-oriented services (e.g., NLP, candidate enrichment, resume parsing). We need to choose languages that optimize both performance and productivity.

---

### Alternatives
- Go only
- Python only
- Java/Kotlin
- Node.js/TypeScript

---

### PrOACT
- **Problem:** Our system must support both fast, concurrent workloads and flexible data processing.
- **Objectives:** Efficient services with high throughput and maintainable codebases for data-heavy tasks.
- **Alternatives:** Monolingual approach (Go or Python), JVM-based stack, JavaScript stack
- **Consequences:** Operating multiple runtimes increases DevOps complexity and requires polyglot development
- **Tradeoffs:** Higher ecosystem complexity vs. performance and productivity gains

---

### Decision
Use **Go** for performance-critical services and **Python** for data processing and NLP. This hybrid approach ensures service-level efficiency while maintaining flexibility in ML and data pipelines.

---

### Tradeoffs - Mitigations
- **Multiple build/deploy pipelines** → Use language-specific CI/CD templates with ArgoCD
- **Polyglot team skillsets** → Cross-training and well-defined service ownership

---

