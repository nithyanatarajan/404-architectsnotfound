# Key User Journeys

## 🚪 Entry Points – Interview Scheduling Triggers

RecruitX supports three distinct initiation channels:

1. **📨 InterviewLogger Webhook**
    - Webhook triggers scheduling via `interviewLogger-wrapper`
    - Emits `InterviewRequested` event

2. **💬 Chatbot Interface**
    - Recruiter uses natural-language (e.g., “Schedule Java round for Ananya”)
    - Parsed by `chatbot-interpreter`, triggers same workflow

3. **🖥️ Dashboard (Manual UI)**
    - Recruiter initiates from Flutter-based UI
    - Useful for overrides, manual or fallback scheduling

All paths converge to:  
Slot Seeker → Scheduler → Notifier → Calendar → Dashboard

## 🧍 Recruiter Journey – Initiate Interview Schedule

- [Outside the system] Recruiter ensures candidate information is available in InterviewLogger.
- [Outside the system] InterviewLogger can be configured to emit webhook when candidate is in some state, say "Ready to
  Schedule"

Once initiated:

- The system fetches interviewer skills, preferences, and availability from
    - **MyMindComputeProfile** – Skills, location, role
    - **MindComputeScheduler** [Assumption] – Preferences, coordination rules
    - **LeavePlanner** – PTO, holidays
    - **Calendar** – Real-time availability
- Based on fetched data and config rules:
    - `Slot Seeker` generates valid time slots for the requested round
    - `Interview Scheduler` applies scoring logic (configurable & weighted)
    - Candidate receives scheduling link (via email)

- The candidate can:
    - ✅ Select a time slot from the list → triggers callback to `RecruitX Next` [Assumption]
    - 🔁 Request alternative slots (reschedule) → triggers new slot generation [Assumption]

- Once system receives the candidate's selection callback:
    - `Interview Scheduler` is triggered
    - It scores potential interviewers based on:
        - Skills
        - Availability at the selected time
        - Configured weights (e.g., time zone, load)
    - The optimal interviewer is selected
- Calendar invites are sent to both the interviewer and candidate.
- The system registers a **push notification channel** for the event using the Calendar API.
- The system receives **webhook callbacks** if either the candidate or interviewer:
    - Accept / Decline / Tentative
    - System auto-reacts based on status

- Based on webhook updates:
    - ✅ If all parties accept: status marked confirmed.
    - ❌ If interviewer declines: system auto-selects next best interviewer, updates invite.
    - ❌ If candidate declines: system notifies recruiter for manual action.
    - 🕐 If no response within a configured timeout: system prompts rescheduling or alerts recruiter.

- Updates are:
    - Logged via Kafka events
    - Synced with InterviewLogger
    - Delivered to recruiter via Messenger and any other configured channels (e.g., email, Slack).

## 🤖 Recruiter + Chatbot – Quick Lookup

- The recruiter sends a natural language query to the chatbot via Messenger:
  > "Who’s available for a Code Pairing Interview next Monday?"

- The chatbot:
    - Parses the intent using an NLP engine (e.g., LangChain + OpenAI).
    - Extracts key entities:
        - **Interview Type**: Code Pairing
        - **Date**: Next Monday
    - Queries the Matcher Service for interviewers based on:
        - Matching skill set
        - Availability on the specified date
        - Preferred round (if defined)
        - Interview load/capacity (e.g., max interviews per week)
        - Leave data (from LeavePlanner)

- The chatbot responds with:
    - A list of **Top 3 interviewers**, ranked by relevance.
    - Each entry includes:
        - Interviewer Name
        - Role / Skill tags
        - Available time slots
        - Preferred rounds
        - Interview load (e.g., "3/5 interviews this week")

- **Optional follow-up interactions**:
    - Book interview directly from chat:
      > "Schedule with Arjun at 2 PM"
    - Request additional options:
      > "Anyone else available after 4 PM?"

## 💻 Recruiter + Web – Dashboard & Reporting

- The recruiter logs into the `RecruitX Next` dashboard via web.

### 📅 Interview Overview Section (Time Range Filterable)

- Shows summary of scheduled interviews within a selected date range.
- Interview statuses:
    - Scheduled
    - Pending Confirmation
    - Completed
    - Declined
    - Reschedule Needed

### 👤 Interviewer Availability Panel

- Displays availability in a calendar or heatmap view.
- Filters available for:
    - Skill sets
    - Interview round preferences
    - Interview load
    - Team or department
- Hover actions show quick insights (e.g., upcoming interviews).

### 📊 Interview Progress Tracker

- Candidate-specific view of the interview journey.
- Tracks:
    - Completed rounds
    - Upcoming interviews
    - Feedback received or pending
- Visual markers for bottlenecks (e.g., missing feedback, slot not confirmed)

### 📈 Reporting Module

- Generate detailed reports on:
    - Interviewer activity (e.g., #interviews, response times)
    - Interview completion/dropout rates
    - Feedback turnaround time
- Output formats:
    - CSV
    - PDF
    - Share via Messenger

### ⚡ Optional Call-to-Actions in Reports

- "Flag Overload" — if interviewers are nearing their weekly cap
- "Send Reminder" — for pending feedback
- "Suggest Slot"— for interviews stuck in unconfirmed state
