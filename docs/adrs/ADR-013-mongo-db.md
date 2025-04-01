**ADR 003: Use MongoDB for Interview and Config Data**

**Status:** Accepted  
**Date:** 2025-03-26  
**Author:** Vishwapriyaj

### Context
We need to store flexible and hierarchical documents for interview mapping, config settings (weights, rounds), and state transitions.

### Alternatives
- PostgreSQL (relational model)
- DynamoDB (key-value store)
- MongoDB (document-oriented)

### PrOACT
- **Problem:** Interview data and configurations are nested and dynamic
- **Objectives:** Flexible schema, fast updates, easy querying
- **Alternatives:** Relational DB, NoSQL document DB
- **Consequences:** MongoDB lacks strong schema guarantees
- **Tradeoffs:** Schema-less flexibility vs. data validation and joins

### Decision
Use MongoDB to store:
- Interview schedules (candidate, time, status, interviewers)
- Configurations (interviewer weights, round preferences)

### Tradeoffs - Mitigations
- Possible schema drift (→ enforce via application-level checks)
- No ACID transactions across documents (→ not needed for this use case)