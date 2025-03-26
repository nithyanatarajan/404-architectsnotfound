# 🧩 Microservices Overview (Event-Driven Architecture)

## 1. **Interviewer Profile Service**

> 📘 Role: Manage and serve interviewer metadata

**Purpose:**
Acts as a gateway over internal directories like MyMindComputeProfile to provide enriched interviewer profiles.

**Features:**

- Exposes API to fetch interviewer skills, grade, timezone, and location
- Performs periodic sync from MyMindComputeProfile / external sources
- Caches enriched profile data with expiry
- Publishes `interviewer_profile.updated` events

**Integrations:**

- MyMindComputeProfile (can be replaced with LinkedIn, LDAP, internal DB)

---

## 2. **Candidate Insights Service**

> 📘 Role: Serve enriched candidate profiles

**Purpose:**
Fetches and standardizes candidate metadata from ATS platforms.

**Features:**

- Exposes API to fetch candidate skillset, experience, and preferences
- Syncs with InterviewLogger (or other ATS)
- Caches transformed candidate data
- Publishes `candidate_profile.updated` events

**Integrations:**

- InterviewLogger or other ATS platforms

---

## 3. **Interviewer Preferences Service**

> 📗 Role: Persist and serve availability and interview-related preferences

**Purpose:**
Central source of truth for interviewer availability preferences and behavioral filters.

**Features:**

- Stores preferred slots, round types, blocklist/savelist logic
- Supports recurring preferences
- Evaluates calendar titles like `Focus Time` or `Interview Slot`
- Caches processed preference data
- Publishes `interviewer_preferences.updated` events

**Integrations:**

- MindComputeScheduler [Assumption]

---

## 4. **Scheduling Config Service**

> ⚙️ Role: Central configuration manager for scoring and selection logic

**Purpose:**
Manages dynamic dimension weightings, function mappings, and runtime overrides.

**Features:**

- Stores matcher configuration (e.g., skill match, timezone match)
- Runtime override support via API/UI
- Cache-backed metadata config
- Publishes `matcher_config.updated` events

**Integrations:**

- Internal only (PostgreSQL, Redis)

### Config Store Design — Metadata-Driven Dimensions

**Data Source Sample Entries:**

| Name                 | Data Source                 | API                             |
|----------------------|-----------------------------|---------------------------------|
| interviewer_skillset | Interviewer Profile Service | `/interviewer/{interviewer_id}` |
| candidate_skillset   | Candidate Insights Service  | `/candidate/{candidate_id}`     |
| interviewer_timezone | Interviewer Profile Service | `/interviewer/{interviewer_id}` |
| candidate_timezone   | Candidate Insights Service  | `/candidate/{candidate_id}`     |
| interviewer_grade    | Interviewer Profile Service | `/interviewer/{interviewer_id}` |
| candidate_experience | Candidate Insights Service  | `/candidate/{candidate_id}`     |

**Matcher Config Sample Entries:**

| Name              | Enabled | Must-Have? | Weight | Fields                                       | Processing Function |
|-------------------|---------|------------|--------|----------------------------------------------|---------------------|
| skillset_matching | true    | true       | 100    | []{interviewer_skillset, candidate_skillset} | match_skillset      |
| timezone_match    | true    | true       | 80     | []{interviewer_timezone, candidate_timezone} | check_timezone      |
| grade_level       | true    | true       | 70     | []{interviewer_grade, candidate_experience}  | match_grade         |

---

## 5. **Availability Evaluator Service**

> ⏰ Role: Evaluate real-time slot-level availability of interviewers

**Purpose:**
Validates whether an interviewer is available for a given time window.

**Features:**

- Cross-checks Calendar events
- Filters out blocked terms via Preferences Service
- Considers leave info (LeavePlanner)
- Caches availability windows per interviewer
- Publishes `availability.checked` and `availability.blocked` events

**Integrations:**

- Calendar, LeavePlanner
- Interviewer Preferences Service

---

## 6. **Matcher & Selector Service**

> 🎯 Role: Score and select the best-fit interviewers

**Purpose:**
Applies scoring logic based on configured dimensions to rank interviewers.

**Features:**

- Fetches profile and availability data
- Applies pluggable processing functions per dimension
- Ranks and returns top N results
- Publishes `interviewer.match.suggested` events

**Integrations:**

- Candidate Insights, Interviewer Profile, Preferences, Config, Availability Services

---

## 7. **Slot Recommender Service**

> 🗓️ Role: Suggest optimal slots for interviews

**Purpose:**
Returns a list of potential interview slots that work across participants.

**Features:**

- Aggregates availability from Availability Evaluator
- Filters by preferences and candidate constraints
- Applies dimension-based slot ranking
- Publishes `slot.recommendation.generated` events

**Integrations:**

- Matcher & Selector Service

---

## 8. **Interview Scheduler**

> 🗓️ Role: Schedules the interview

**Purpose:**
Schedules interview based on given slot.

**Features:**

- Applies dimension-based slot ranking
- Publishes `interview.schedule.generated` events

**Integrations:**

- Matcher & Selector Service

---

## 9. **Chat Interface Service**

> 💬 Role: Chatbot for recruiter interaction

**Purpose:**
Acts as the conversational interface to query availability, book interviews, etc.

**Features:**

- Natural language parsing via LLM/NLP
- Queries Matcher, Recommender, and Tracker services
- Supports fallback flows (e.g., no match found)
- Publishes `chat.query.asked` and `chat.action.triggered` events

**Integrations:**

- Messenger
- Internal services only

---

## 10. **Dashboard & Insights Service**

> 📊 Role: UI layer for recruiters

**Purpose:**
Provides real-time view of interviews, availability, progress, and triggers.

**Features:**

- Initiate new interviews
- Filtered views of availability and interview load
- Dashboard widgets powered by event logs
- Publishes `ui.action.triggered` events

**Integrations:**

- All backend services via APIs or event streams

---

## 11. **Reporting & Analytics Service**

> 📈 Role: Analytics, history, and reporting engine

**Purpose:**
Maintains denormalized historical views for analytics and reporting.

**Features:**

- Ingests events from all services via streams
- Runs ETL jobs for aggregations (interview load, completion rate, feedback delays)
- Exposes dashboard reports via API/UI
- Publishes `report.generated` events (for Messenger or Email delivery)

**Integrations:**

- Kafka/Event Bus (for ingest)
- All services (read-only)

---

## ✅ System-Level Properties

- Every service:
    - Owns its **data and cache** (bounded context)
    - **Subscribes to relevant events** from event bus (e.g., Kafka, Pub/Sub)
    - Exposes **REST/GraphQL APIs** for direct calls where needed
    - Emits **audit and domain events** to central topic

