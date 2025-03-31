**ADR 002: Use Kafka for Asynchronous Communication**

**Status:** Accepted  
**Date:** 2025-03-26  
**Author:** Vishwapriyaj

### Context
The system involves asynchronous events like slot syncing, slot selection, and interview state updates. Services must communicate without being tightly coupled.

### Alternatives
- REST APIs for all communication
- RabbitMQ / AWS SQS
- Apache Kafka

### PrOACT
- **Problem:** Services need to react to events (e.g. slot updates, candidate selections) in real-time without being synchronous
- **Objectives:** Scalability, fault tolerance, decoupling
- **Alternatives:** REST, RabbitMQ, Kafka
- **Consequences:** Kafka adds operational overhead but improves scalability and decoupling
- **Tradeoffs:** More infra effort vs. better service isolation and durability

### Decision
Use Kafka for internal pub-sub and queues:
- Topic: `availability-update-topic` (slot data updates)
- Queue: `interview-schedule-queue` (candidate selections)
- Topic: `interview-status-topic` (status events)

### Tradeoffs - Mitigations
- Learning curve and infra management (→ use managed Kafka)
- Consumer lag can delay downstream systems (→ use monitoring and retries)