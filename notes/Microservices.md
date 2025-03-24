## Microservices Overview

### 1. Interviewer Information Service

> Role: Read Interviewer Profile

**Purpose:**
Fetch interviewer profile data.

**Features:**

- Returns interviewer skills, seniority, location, timezone
- Acts as a layer over internal directory (MyMindComputeProfile)
- Supports caching and data enrichment

**3rd-Party Integrations:**

- MyMindComputeProfile (can be swapped with LinkedIn, internal DB)

### 2. Candidate Information Service

> Role: Read Candidate Insights

**Purpose:**
Fetch candidate skillsets, preferences and other metadata.

**Features:**

- Standardizes structure for downstream logic

**3rd-Party Integrations:**

- InterviewLogger (or other ATS)

### 3. Interviewer Preference Service

> Role: Interviewer's Interview Preference Management

**Purpose:**
Retrieve interviewer’s preferred interview times, round information, etc.

**Features:**

- Saves and retrieves interviewers' preferred timeslots
- Saves and retrieves interviewers' interview round preference
- Allow keeping track of blocklist and savelist to check against google calendar availability.
    - Example: Always skip meeting that contains `Focus Time` or `ClientX`
    - Example: Always allow meeting that contains `Blocked for interview slot` or `interview slot`
- Supports recurring preferences

**3rd-Party Integrations:**

- MindComputeScheduler (if possible)

### 4. Interview Configuration Service

> Interview Configuration Control

**Purpose:**
Manage dimension metadata (enable/disable, weight, function mappings) for slot and interviewer selection.

**Features:**

- Central config management
    - Easily extensible — add new dimensions without code changes
- Dynamically configurable via API/UI
- Runtime override support for specific requests

**3rd-Party Integrations:**

- Internal only (PostgreSQL, Redis)

#### Config Store Design — Metadata-Driven Dimensions

**Data Source Sample Entries:**

| Name                 | Data Source                     | API                             |
|----------------------|---------------------------------|---------------------------------|
| interviewer_skillset | Interviewer Information Service | `/interviewer/{interviewer_id}` |
| candidate_skillset   | Candidate Information Service   | `/candidate/{candidate_id}`     |
| interviewer_timezone | Interviewer Information Service | `/interviewer/{interviewer_id}` |
| candidate_timezone   | Candidate Information Service   | `/candidate/{candidate_id}`     |
| interviewer_grade    | Interviewer Information Service | `/interviewer/{interviewer_id}` |
| candidate_experience | Candidate Information Service   | `/candidate/{candidate_id}`     |

**Matcher Config Sample Entries:**

| Name              | Enabled | Must-Have? | Weight | Fields                                       | Processing Function |
|-------------------|---------|------------|--------|----------------------------------------------|---------------------|
| skillset_matching | true    | true       | 100    | []{interviewer_skillset, candidate_skillset} | match_skillset      |
| timezone_match    | true    | true       | 80     | []{interviewer_timezone, candidate_timezone} | check_timezone      |
| grade_level       | true    | true       | 70     | []{interviewer_grade, candidate_experience}  | match_grade         |

### 5. Interviewer Availability Service

> Role: Validate Slot Availability

**Purpose:**
Check if an interviewer is available at a given datetime and range.

**Features:**

- Caches availability (e.g., 4h expiry)
- Handles conflicting meetings or time off
- Marks unavailability of interviewer on cancellation | Needed for rescheduling

**Integrations:**

- Interviewer Preference Service

**3rd-Party Integrations:**

- Calendar
- Leaver Planner

### 6. Interviewer Selector

**Purpose:**
Main orchestrator to score and select interviewers.

**Features:**

- Allows to configure dimensions
- Fetches candidate information from Candidate Information Service
- Fetches interviewer information from Interviewer Information Service
- Fetches configured dimensions from Interview Configuration Service
- Dynamically applies processing functions per active dimension
- Supports scoring and ranking logic

**Integrations:**

- Interviewer Preference Service
- Interviewer Availability Service

**3rd-Party Integrations:**

- Internal services only

### 7. Interview Slot Suggester

> Role: Provides list of available slots for candidate interview

**Purpose:**
Provides list of slots based of configurable dimension.

**Features:**

- Allows to configure dimensions
- Fetches candidate information from Candidate Information Service
- Fetches interviewer information from Interviewer Information Service

**Integrations:**

- Interview Configuration Service
- Interviewer Selector

### 8. NameMe Service

**Purpose:**
Provides chatbot and UI interface for recruiters and interviewers

**Features:**

- Enquires interviewer for a set if criteria
- Check status of interviews
- Other reporting information

### 9. Orchestrator

**Purpose:**
???

**Features:**
???

### 10. Reporting Service

**Purpose:**
???

**Features:**

1. Runs ETL jobs and keeps old of completed actions in the system for faster querying purposes

## 📝 Summary of Architectural Decisions

| Decision Area            | Chosen Approach                                             | Reasoning                                                                                           |
|--------------------------|-------------------------------------------------------------|-----------------------------------------------------------------------------------------------------|
| Architecture Style       | Event-Driven Microservices                                  | Scales well, allows independent services for each dimension, supports real-time + batch processing. |
| Config Management        | Database-driven + API-based Config Service                  | Supports dynamic enabling/disabling of dimensions, weight adjustments, and per-request overrides.   |
| 3rd Party API Wrappers   | Microservices for each external integration                 | Prevents direct dependency on external APIs, making it easier to switch providers.                  |
| Data Processing          | Metadata-driven approach                                    | Allows adding new dimensions dynamically without modifying the core system.                         |
| Request Format           | Flexible JSON payload                                       | Enables passing new dimensions without changing API contracts.                                      |
| Selection Flow           | Decision Engine that dynamically applies enabled dimensions | Ensures only relevant filters are applied per request.                                              |
| Storage                  | PostgreSQL (for persistence) + Redis (for fast access)      | Balances long-term storage with performance optimization.                                           |
| Tech Stack               | Go (Fiber) + Flutter + PostgreSQL + Kafka + Redis           | Optimized for speed, scalability, and maintainability.                                              |
| Caching Strategy         | 4-hour expiry on frequently changing data                   | Reduces API calls while keeping data reasonably fresh.                                              |
| Manual Refresh Mechanism | Chatbot + UI interaction                                    | Allows manual intervention when needed.                                                             |

> Need to think of Authentication, Authorisation via RBAC, Tech Stack and Deployment strategies

## 📝 Flow of information

1. Recruiter adds candidate interview to interviewLogger and informs RecruitX (our system) via UI or chatbot to schedule
   interview.
2. The system (`Orchestrator`) checks with `Interview Slot Suggester` for a list of slots available and then coordinates
   with `MindComputeScheduler` and send an interview link to the candidate.
3. The candidate can choose from the list of available slots or ask for reschedule.
4. [If Reschedule] The system (`Orchestrator`) should generate a different set of slots and then send another link to
   candidate.
5. [If Slot Selected] The system(`Orchestrator`) should then talk with `Interviewer Selector` to select a interviewer
   available for the candidate.
6. The system(`Orchestrator`) should then send a google calender invite and necessary notification (chats, whatsapps).
   `Q: Do we need another service here?`
7. [If interviewer rejects] The system should initiate the interviewer selection step (Step 5 and Step 6)
8. [If no matching interviewer] The system should inform recruiter
9. [If candidate rejects] The system should inform recruiter
