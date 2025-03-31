**ADR 001: Use Redis for Caching Interview Slots**

**Status:** Accepted  
**Date:** 2025-03-26  
**Author:** Vishwapriyaj

### Context
The system frequently retrieves available interview slots for different tech stacks and rounds. These queries are read-heavy and need to be performant. MongoDB is the source of truth but is not optimized for high-volume, low-latency reads.

### Alternatives
- Query directly from MongoDB
- Use in-memory Java maps (non-shared)
- Use Redis as a centralized cache

### PrOACT
- **Problem:** MongoDB reads are too slow for real-time slot suggestions
- **Objectives:** Fast, low-latency, scalable read access for slot availability
- **Alternatives:** MongoDB reads, in-memory caching, Redis
- **Consequences:** Redis adds infra cost but improves performance
- **Tradeoffs:** Complexity vs. performance gains

### Decision
Use Redis to cache available slots by tech stack + round combinations. It enables fast retrieval, reduces DB pressure, and supports real-time slot lookups from chatbot and candidate interfaces.

### Tradeoffs - Mitigations
- Redis downtime would degrade performance (→ fallback to MongoDB)
- Cache invalidation must be carefully managed (→ done via Kafka updates from sync service)