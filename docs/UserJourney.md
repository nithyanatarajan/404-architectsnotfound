
# RecruitX – Updated User Journeys (No Redis)

---

## 🚪 Entry Points – Interview Scheduling Triggers

RecruitX supports three distinct initiation channels:

1. **📨 InterviewLogger Webhook**
    - Webhook triggered when a candidate reaches the "Ready to Schedule" stage.
    - `InterviewLogger Wrapper` receives it and inserts a scheduling request into a Kafka-backed queue.
    - `Candidate Service` listens to this queue.

2. **💬 Chatbot Interface**
    - Recruiter types natural language queries (e.g., “Schedule Java round for Ananya”)
    - Parsed by the `Chatbot Interpreter`
    - Interacts with `Slot Seeker` and `Interview Scheduler` via REST APIs

3. **🖥️ Dashboard**
    - Flutter-based UI lets recruiters initiate/reschedule interviews and view statuses.
    - Talks to green house wrapper using REST apis

All paths converge to the following components:
- `Candidate Service` → writes scheduling request
- `Slot Seeker` → evaluates available slots using interviewer data, candidate data config weights
- `Interview Scheduler` → selects interviewers based on config weights and selected slots
- `Notifier Service` → sends updates to Calendar, InterviewLogger, candidate, and recruiter

> 💡 All slot evaluations and interviewer availability checks are done by internal services.
> No Redis or external API reads are made at runtime — data is pre-synced.

---

## 🧍 Recruiter Journey – Scheduling an Interview

- Recruiter moves candidate to “Ready to Schedule” in InterviewLogger
- InterviewLogger emits webhook → `InterviewLogger Wrapper` → Kafka Queue
- `Candidate Service` parses the resume and gets candidate information for scheduling interviews:
  - Candidate’s round and tech stack
- `Slot Seeker` generates available slots using:
  - MongoDB (pre-synced data from `Harvest Sync`)
  - Config logic from `Config Service`
  - Sends list of available slots to the `Candidate Service`
- The `Candidate Service` sends the available slots to `Good Time`, which will send the information to the candidate
- `Candidate Service` listens to the `Good Time` webhook for selected slot details and forwards the selected slots to the `Interview Schedule`
- `Interview Scheduler` consumes data from `Config Service` and `Slot Seeker` to find the top matching interviewers and sends the data to `Notifier Service`
- `Notifier Service` will notify the interviewers google calendar, candidate's calendar and messenger

---

## 🔁 Rescheduling Flow

- Triggers:
  - Candidate declines or cancels
  - Interviewer declines calendar invite
- `Interview Scheduler` re-initiates if:
  - Reschedule is within allowed threshold
  - Config allows auto-pick
- If outside threshold, recruiter is notified manually

---

## 🤖 Chatbot Interaction Flow

- Recruiter asks: “Who’s free for DS round next Tuesday?”
- `Chatbot Interpreter` parses query:
  - Role: DS
  - Date: Next Tuesday
- Interacts with:
  - `Slot Seeker` to generate possible interviewer-time combinations
  - `Config Service` to apply scoring rules
- Sends back a response with:
  - Top interviewers
  - Scores, capacity, prior round performance
- Recruiter can respond: “Book Arjun at 3 PM” → creates a schedule request

---

## 💻 Recruiter Dashboard

- Displays real-time state using data from:
  -InterviewLogger APIs
- Sections include:
  - 📅 Interview Calendar
  - ✅ Status per round/candidate
  - 🧠 Insights on scheduling load
  - 📊 Reports exportable in CSV/PDF

---

## 🔄 Data Sync: Harvest Sync

- Periodically pulls data from:
  - Calendar
  - LeavePlanner
  - MindComputeScheduler
  - MyMindComputeProfile
- Populates MongoDB with:
  - Interviewer availability
  - Tech stack capabilities
  - PTO or leave details
- No live API reads happen during scheduling

---

## ⚠️ Failure Handling & DLQ

- All async processing (webhooks, Kafka queues) is backed by retries
- Failures go to DLQ (Dead Letter Queue) for reprocessing
- Alerting is integrated with Prometheus/Grafana dashboards
- Examples:
  - Webhook not received
  - Interviewer not available
  - Calendar push fails
- Notification fallback: recruiter alerted via Chat + email
