# Key User Journeys – RecruitX

## 🚪 Entry Points – Interview Scheduling Triggers

RecruitX supports three distinct initiation channels:

1. **📨 InterviewLogger Webhook**
    - Triggered when a candidate reaches the "Ready to Schedule" stage.
    - `InterviewLogger Wrapper` receives the webhook and enqueues a scheduling request via Kafka.
    - `Candidate Service` listens to this queue and initiates the flow.

2. **💬 Chatbot Interface**
    - Recruiter types natural language queries (e.g., “Schedule Java round for Ananya”).
    - Parsed by the `Chatbot Interpreter`.
    - Interacts with `Slot Seeker` and `Interview Scheduler` via internal REST APIs.

3. **🖥️ Dashboard**
    - Flutter-based UI allows recruiters to **view** interview statuses and reports.
    - (In MVP, dashboard does **not** support initiating or rescheduling interviews.)
    - Connects to InterviewLogger Wrapper via REST APIs for candidate and status info.

All paths converge into the scheduling pipeline:

- `Candidate Service` → creates a scheduling request
- `Slot Seeker` → evaluates slots using interviewer metadata and config weights
- `Interview Scheduler` → picks best-fit interviewers
- `Notifier Service` → sends updates to Calendar, InterviewLogger, and recruiter

> 💡 No Redis is used. All runtime reads are served from MongoDB (pre-synced).  
> External APIs are accessed only by sync jobs — not during live request handling.

---

## 🧍 Recruiter Journey – Scheduling an Interview

1. Recruiter moves a candidate to “Ready to Schedule” in InterviewLogger.
2. InterviewLogger emits a webhook → `InterviewLogger Wrapper` → Kafka queue.
3. `Candidate Service`:
    - Parses the resume and fetches round + skill requirements.
4. `Slot Seeker`:
    - Reads from MongoDB (synced via `Harvest Sync`)
    - Uses weights/configs from `Config Service`
    - Returns list of valid time slots.
5. `Candidate Service` sends the slots to MindComputeScheduler (which shares them with the candidate).
6. Candidate selects a slot → `MindComputeScheduler` webhook hits RecruitX → forwarded to `Interview Scheduler`.
7. `Interview Scheduler`:
    - Uses rules from `Config Service` + slot info from `Slot Seeker`
    - Selects interviewers and pushes event to `Notifier Service`.
8. `Notifier Service`:
    - Updates Calendar, InterviewLogger, and sends recruiter/candidate notifications via chat/email.

---

## 🔁 Rescheduling Flow

Triggers:

- Candidate cancels or declines
- Interviewer declines invite or is unavailable

Flow:

- `Interview Scheduler` attempts auto-reschedule if:
    - Within allowed retry threshold
    - Auto-pick is enabled in config
- If not, fallback alert is sent to recruiter via email + chatbot.

---

## 🤖 Chatbot Interaction Flow

- Recruiter asks: “Who’s free for DS round next Tuesday?”
- `Chatbot Interpreter` parses:
    - Role: DS
    - Date: Next Tuesday
- Services used:
    - `Slot Seeker` → generates availability
    - `Config Service` → scoring and rule weights
- Bot responds with:
    - Top matching interviewers
    - Scores, load info, prior round experience
- Recruiter replies: “Book Arjun at 3 PM” → a schedule request is created.

> 💬 Chatbot supports scheduling, rescheduling, and slot discovery  
> All data is from the central MongoDB cache

---

## 💻 Recruiter Dashboard

- UI shows **real-time status** based on:
    - InterviewLogger APIs
    - Internal scheduling status
- Sections include:
    - 📅 Interview Calendar
    - ✅ Per-round/candidate status
    - 🧠 Load Insights (interviewer-level)
    - 📊 Exportable reports (CSV/PDF)

> 🛑 **Note**: No scheduling actions from dashboard in MVP.  
> It is **read-only** and acts as an observability layer.

---

## 🔄 Data Sync: Harvest Sync

- Periodically pulls data from:
    - Calendar
    - LeavePlanner
    - MindComputeScheduler
    - MyMindComputeProfile
- Populates MongoDB with:
    - Interviewer availability
    - Skill matrix and preferences
    - Time-off and holiday data

> No runtime API calls.  
> Cache freshness is visible to chatbot/dashboard users.

---

## ⚠️ Failure Handling & DLQ

- All async processing (e.g., webhooks, Kafka) is backed by retries
- Failures are routed to **Dead Letter Queues (DLQs)** per topic
- Alerting is integrated via Prometheus + Grafana
- Sample failure scenarios:
    - Webhook missed or malformed
    - Interviewer not found or double-booked
    - Calendar push fails

Fallbacks:

- Recruiter alerted via Chatbot + Email
- DLQ events can be manually replayed if needed
