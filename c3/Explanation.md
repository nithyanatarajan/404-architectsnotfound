# C3 Diagram: Interview Scheduler Service

---

## Container: Interview Scheduler Service
Responsible for consuming slot selection events, selecting interviewers based on configuration, persisting interview schedules, and notifying downstream systems (e.g., InterviewLogger, recruiter portal).

---

## Components

### 1. SlotSelectionConsumer
- Subscribes to `interview-schedule-queue` Kafka topic
- Parses and validates candidate slot selections
- Triggers interviewer selection

### 2. InterviewerSelector
- Fetches interviewer weights and preferences from Config Service
- Applies weighted logic to determine top 2 available interviewers
- Handles load balancing and round-specific preferences

### 3. ScheduleValidator
- Ensures the selected time slot is still available
- Verifies interviewer availability and conflicts
- Falls back or retries selection if needed

### 4. InterviewPersistenceManager
- Persists final interview mapping to MongoDB
- Maintains status lifecycle (Scheduled, Rescheduled, Cancelled)

### 5. NotificationDispatcher
- Publishes status events to Kafka (`interview-status-topic`)
- Sends webhook callbacks or API calls to InterviewLogger and downstream consumers

### 6. MetricsLogger
- Captures success/failure counts, processing times, and scheduling decisions
- Pushes metrics to Prometheus via OpenTelemetry

---

## External Dependencies

- **Kafka Topics**: `interview-schedule-queue`, `interview-status-topic`
- **MongoDB**: For storing interview mappings
- **Config Service**: For fetching interviewer weights and rules
- **InterviewLogger**: For notifying scheduled interviewers