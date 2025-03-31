# 🧭 Diagrams – RecruitX Architecture

This document indexes all key architectural diagrams for RecruitX Next, from high-level system context to low-level
component boundaries.

---

## 🏗️ High-Level Design (HLD)

- **Diagram**:  
  ![HighLevelDesign.png](../images/HighLevelDesign.png)

- **Purpose**: Captures end-to-end system responsibilities, external integrations (InterviewLogger, MindComputeScheduler, Calendar), and
  major service roles.

- **Highlights**:
    - Event-driven microservices
    - Config and cache ownership
    - Secure communication via Kong + OIDC + OPA
    - Observability and GitOps-based CI/CD pipelines

---

## 🌍 C1: System Context Diagram

- **Diagram**:  
  ![SystemContext.png](../images/SystemContext.png)  
  ![SystemContext-key.png](../images/SystemContext-key.png)

- **Purpose**: Shows RecruitX as a black box in relation to external users and systems

- **Recommended Nodes**:
    - Users: Recruiters, Interviewers, Candidates
    - External systems: InterviewLogger, MindComputeScheduler, MyMindComputeProfile, Calendar
    - RecruitX platform boundary and core capabilities

---

## 📦 C2: Container Diagram (Planned)

- **Purpose**: Zoom into the RecruitX system and show major containers/services and their interactions

- **To Cover**:
    - Key microservices: `candidate-service`, `interview-scheduler`, `slot-seeker`, `calendar-adapter`, etc.
    - Infrastructure components: Kafka, Mongo, Redis, Config-service
    - Cross-service flows: Event vs API

---

## 🧠 C3: Component Diagram – `interview-scheduler` (Planned)

- **Purpose**: Show internal structure of the scheduler service
- **To Cover**:
    - Event consumers (e.g., `InterviewRequested`, `SlotSelected`)
    - Scoring engine using `config-service` rules
    - Calendar and availability lookups
    - Slot conflict resolution logic
    - Outgoing events and system triggers

---

## ✅ To-Do

- [ ] Finalize container breakdown for C2
- [ ] Add C3 for `interview-scheduler`
