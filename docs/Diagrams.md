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

**Purpose**: Shows RecruitX as a black box in relation to external users and systems

![SystemContext.png](../images/C1SystemContext.png)

## 📦 C2: Container Diagram

**Purpose**: Zoom into the RecruitX system and show major containers/services and their interactions

![ContainerDiagram.png](../images/C2ContainerDiagram.png)

## 🧠 C3: Component Diagram

**Purpose**: Show internal structure of the scheduler service

### `interview-scheduler`

![C3InterviewScheduler.png](../images/C3InterviewScheduler.png)

### `slot-seeker`

![C3SlotSeeker.png](../images/C3SlotSeeker.png)

### `harvest-sync`

![C3HarvestSync.png](../images/C3HarvestSync.png)

### `notifier-service`

![C3NotifierService.png](../images/C3NotifierService.png)

## 🧩 C4: Component Diagram

**Purpose**: Show internal structure of the scheduler service

### `interview-scheduler`

![C4InterviewScheduler.png](../images/C4InterviewScheduler.png)

### `slot-seeker`

![C4SlotSeeker.png](../images/C4SlotSeeker.png)

### `harvest-sync`

![C4HarvestSync.png](../images/C4HarvestSync.png)

### `notifier-service`

![C4NotifierService.png](../images/C4NotifierService.png)
