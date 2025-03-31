# RecruitX Next – Interview Scheduling Platform | Architectural Kata 2025

> The comeback of a loved tool—redesigned, reimagined.

Welcome to our architectural submission for **ArchKata 25**. RecruitX Next is a resilient, extensible, and observable
interview scheduling platform that automates recruiter workflows and provides fallback mechanisms for real-world edge
cases.

---

## 📌 Problem Statement

Recruiters at MindCompute are spending far too much time manually coordinating interviews—matching skills, checking
availability, avoiding scheduling conflicts, and handling declines. The current process involves multiple systems
(InterviewLogger, MindComputeScheduler, MyMindComputeProfile, LeavePlanner) but no centralized intelligence or automation. The result? Missed
interviews, double bookings, rescheduling chaos, frustrated interviewers and candidates.

Our goal is to streamline and automate the **interviewer discovery**, **scheduling**, **rescheduling**, and
**notification flow** with a smart, integrated system and chatbot interface—reducing manual effort and accelerating
the hiring process.

---

## ✨ Solution Highlights

- Event-driven microservices with Kafka + REST APIs
- Config-driven scheduling logic (weighted by skills, load, time zones)
- NLP-enabled chatbot and Flutter dashboard interface
- Manual override support for conflict resolution
- GitOps-first deployments with full observability stack

---

## 📁 Architecture Docs

| Doc Name                                                | Description                                    |
|---------------------------------------------------------|------------------------------------------------|
| [`ArchitectureStyle.md`](./docs/ArchitectureStyle.md)   | Core architecture type and interaction styles  |
| [`Characteristics.md`](./docs/Characteristics.md)       | System qualities and how they are achieved     |
| [`Tradeoffs.md`](./docs/Tradeoffs.md)                   | Design tradeoffs and decision rationale        |
| [`Techstack.md`](./docs/Techstack.md)                   | Tools, languages, and framework choices        |
| [`AITools.md`](./docs/AITools.md)                       | AI/NLP tools like Agno and chatbot interpreter |
| [`DeploymentStrategy.md`](./docs/DeploymentStrategy.md) | GitOps, Helm, and platform-agnostic setup      |
| [`Microservices.md`](./docs/Microservices.md)           | Responsibilities and API/event interaction map |
| [`ADRsList.md`](./docs/ADRsList.md)                     | List of ADRs                                   |
| [`Diagrams.md`](./docs/Diagrams.md)                     | List of diagrams and flows                     |

---

## 📘 Reference Docs

| Doc Name                                              | Description                                   |
|-------------------------------------------------------|-----------------------------------------------|
| [`Glossary.md`](./docs/Glossary.md)                   | Roles and domain terms used across the system |
| [`UserJourneys.md`](./docs/UserJourneys.md)           | Key User Journeys                             |
| [`AssumptionsAndFAQ.md`](./docs/AssumptionsAndFAQ.md) | Assumptions, Functional Decisions and FAQs    |

---

## 🧠 Summary

RecruitX Next embraces event-driven principles, secure API access, observable workflows, and fallback-driven
resilience — all tailored for real-world interview coordination challenges.

> This repository is our ArchKata 25 response. All docs and decisions reflect architectural thinking, not
> implementation.

> Please find the zoom recording about the explanation of our High level design here ->
> https://thoughtworks.zoom.us/rec/share/ufO5CRt8eDqcsHBrBaX-5Vx_v7KGSagWUdRIdv_Jb9zLnkbAICMlLqXavJ5xPp0K.QGk6K786UQf0w6Z9
> Passcode: 1=ww!e16

Thank you for reviewing!

