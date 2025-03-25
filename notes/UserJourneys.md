# Key User Journeys

## 🧍 Recruiter Journey – Initiate Interview Schedule

- [Outside the system] Recruiter ensures candidate information is available in InterviewLogger.
- Recruiter initiates interview scheduling in `RecruitX Next` via chatbot, or web interface for the selected
  candidate.
- The system fetches interviewer skills, preferences, and availability from MyMindComputeProfile, MindComputeScheduler[Assumption], and Leave
  Planner.
- Based on this data, the system generates valid time slots and sends a scheduling link to the candidate.
- The candidate can:
    - ✅ Select a time slot from the list.
    - 🔁 Request alternative slots (reschedule).

- [If Slot Selected]
    - [Assumption] MindComputeScheduler sends a callback to `RecruitX Next` with the selected slot.

- [If Reschedule Requested]
    - The system generates a new set of time slots and sends an updated scheduling link to the candidate.

- The system selects the optimal interviewer based on skills, availability, and load.
    - 📌 These dimensions are configurable and weighted.

- Calendar invites are sent to both the interviewer and candidate.
- The system registers a **push notification channel** for the event using the Calendar API.
- The system receives **webhook callbacks** if either the candidate or interviewer:
    - Accepts
    - Declines
    - Changes their RSVP status

- Based on webhook updates:
    - ✅ If all parties accept: status marked confirmed.
    - ❌ If interviewer declines: system auto-selects next best interviewer, updates invite.
    - ❌ If candidate declines: system notifies recruiter for manual action.
    - 🕐 If no response within a configured timeout: system prompts rescheduling or alerts recruiter.

- Notifications are sent via Messenger and any other configured channels (e.g., email, Slack).
- InterviewLogger is updated with the latest interview schedule and status.

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
