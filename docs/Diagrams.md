# 🧭 Diagrams – RecruitX Architecture

This document indexes all key architectural diagrams for RecruitX Next, from high-level system context to low-level
component boundaries.

---

## 🏗️ High-Level Design (HLD)

**Purpose**: Captures end-to-end system responsibilities, external integrations (InterviewLogger, MindComputeScheduler, Calendar), and
major service roles.
 
![HLD.png](../images/HLD.png)

All internal REST calls are secured using a 🔐 **Secure Internal Mesh**:

- **Authentication:** Okta-issued JWTs (OIDC)
- **Authorization:** OPA policies (RBAC)
- **Encryption & Routing:** mTLS via Consul + Envoy

**Microservice Responsibilities & Interactions:**

| Service                 | Responsibility Summary                                                                                                    | Interactions                                                                                                   |
|-------------------------|---------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------|
| **Harvest Sync**        | Periodically fetches data from MyMindComputeProfile, MindComputeScheduler, LeavePlanner, Calendar                                           | ✅ Pulls from: External APIs<br>✅ Writes to: MongoDB                                                            |
| **InterviewLogger Wrapper**  | Handles incoming webhook and API requests from InterviewLogger                                                                 | ✅ Consumes: InterviewLogger Webhook<br>✅ Calls: Candidate Service  <br>   ✅ Publishes: `interviewLogger-events`          |
| **Candidate Service**   | Handles interview scheduling requests from InterviewLogger or dashboard <br> Also talks to MindComputeScheduler for sending schedule links | ✅ Publishes: `interview-schedule-queue`<br>✅ Calls: Slot Seeker, MindComputeScheduler <br> ✅ Consumes: `interviewLogger-events` |
| **Slot Seeker**         | Computes valid time slots using availability, leave, and config rules                                                     | ✅ Reads: MongoDB (harvested data)<br>✅ Calls: Config Service                                                   |
| **Interview Scheduler** | Scores and assigns interviewers for selected slots                                                                        | ✅ Consumes: `interview-schedule-queue`<br>✅ Calls: Config Service, Notifier Service                            |
| **Notifier Service**    | Sends calendar invites, chat notifications, and emails                                                                    | ✅ Notifies: Calendar, Messenger, Email APIs                                                           |
| **Config Service**      | Stores and serves scoring weights, preferences, and round rules                                                           | ✅ Reads/Writes: MongoDB<br>✅ Called by: Slot Seeker, Interview Scheduler                                       |
| **Chatbot Interpreter** | Parses recruiter queries via Messenger, triggers slot/schedule                                                          | ✅ Invoked from: Messenger<br> ✅ Notifies: Messenger<br>✅ Calls: Slot Seeker, Interview Scheduler           |

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
