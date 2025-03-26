## System Flow: Recruiter Schedules an Interview
> WIP

### 1. Candidate Shortlisted in InterviewLogger

- **Trigger:** InterviewLogger updates status to "Ready to Schedule"
- **Integration:**
    - API/Webhook → `scheduler`
    - Payload includes: candidate ID, required skills, round type, recruiter ID

### 2. Interviewer Matching

- `scheduler` invokes `matcher` via **API** to get top interviewers:
    - `matcher` queries:
        - `interviewer-profile-service` for skill sets (**API**)
        - `leave-planner-service` for leave info (**API**)
        - `interviewer-preferences-service` for preferences and available time slots (**API**)
    - Returns top 3 suitable interviewers to `scheduler`

### 3. Slot Preparation

- `scheduler` calls `availability-evaluator` (**API**) to compute available time slots
- Emits **event**: `InterviewSlotsPrepared`

### 4. Candidate Slot Selection

- `notifier-service` receives `InterviewSlotsPrepared` and sends scheduling link to candidate (**email/chat API**)
- Candidate selects a slot → triggers **API** call to `scheduler`

### 5. Interview Confirmation

- `scheduler` sends invites to:
    - `availability-evaluator` (**API**)
    - Emits **event**: `InterviewScheduled`

### 6. Calendar Response (Accept/Decline)

- `availability-evaluator` emits events:
    - `InterviewAccepted`
    - `InterviewDeclined`

### 7. Reschedule Flow (if declined)

- `scheduler` consumes `InterviewDeclined`
- Attempts to:
    - Re-match interviewer (**API → matcher-service**)
    - Get new slots (**API → availability-evaluator**)
    - Emits **event**: `InterviewRescheduleInitiated`
- `notifier-service` sends updated scheduling link to candidate (**email/chat API**)

### 8. Fallback Manual Flow

- After N retries or timeouts:
    - Emits **event**: `ManualSchedulingRequired`
    - `recruiter-dashboard-service` displays alert
    - Recruiter manually overrides via dashboard (**API → scheduler**)

### 9. Final Confirmation

- `scheduler` updates:
    - `candidate-insights` (**API**)
    - Emits events to:
        - `notifier-service`
        - `reporting-service`
        - `recruiter-dashboard-service`

### 10. Post-Interview

- Feedback submitted in InterviewLogger
- `candidate-insights` emits **event**: `InterviewFeedbackSubmitted` → `reporting-service`

---

## Edge Cases & Handling

| Scenario                         | Handling                                                                                       |
|----------------------------------|------------------------------------------------------------------------------------------------|
| No interviewer match             | `scheduler` emits `ManualSchedulingRequired` → dashboard alert                                 |
| Decline by candidate/interviewer | `InterviewDeclined` triggers retry or fallback logic                                           |
| Timeout                          | `scheduler` emits retry or alert event to `notifier-service` and `recruiter-dashboard-service` |
| Retry limit exceeded             | Manual flow initiated via dashboard                                                            |
| Feedback missing                 | Alert via `recruiter-dashboard-service`, escalated through `notifier-service`                  |
