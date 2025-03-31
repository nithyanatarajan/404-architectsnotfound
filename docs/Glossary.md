# 📘 Glossary

## User Roles in RecruitX

| User Role              | Description                                                           | Primary Interactions                                     | Permissions/Access                                                                |
|------------------------|-----------------------------------------------------------------------|----------------------------------------------------------|-----------------------------------------------------------------------------------|
| **Recruiter**          | Person responsible for scheduling and coordinating interviews         | Triggers selection via UI or chatbot                     | - Selects candidates<br>- Adjusts rules (optional)<br>- Views interviewer matches |
| **Candidate**          | Applicant applying for a role                                         | Passive entity; data fetched from ATS (e.g., InterviewLogger) | - No direct system interaction                                                    |
| **Interviewer**        | Employee who may be selected to conduct interviews                    | Profile & availability fetched by system                 | - Manages calendar/preferences externally                                         |
| **Admin/Configurator** | Internal system operator managing dimension rules and system settings | Uses admin UI/API to manage config                       | - Enable/disable dimensions<br>- Set weights<br>- Manage overrides                |
| **System Bot**         | Automation agent for triggering tasks (e.g., refresh, notify)         | Works through APIs, triggers via UI/chatbot              | - Refresh caches<br>- Initiate matchmaking                                        |

**Notes:**

- Roles may overlap in some cases (e.g., recruiter may act as admin).
- Access to services is governed by role-based authorization (if implemented).

## Integrated Systems and Their Responsibilities

| System Name   | Type                            | Purpose                                                            | Example Data Provided                                     | Role in Interviewer Selector               |
|---------------|---------------------------------|--------------------------------------------------------------------|-----------------------------------------------------------|--------------------------------------------|
| MyMindComputeProfile        | Employee Data Platform          | Stores employee information like skills, office locations          | Interviewer skills, location, seniority, current role     | Source for interviewer metadata            |
| InterviewLogger    | Applicant Tracking System (ATS) | Manages candidate profiles, resumes, and job applications          | Candidate skills, role applied for, resume data           | Source for candidate info                  |
| MindComputeScheduler      | Interview Coordination Platform | Manages interviewer preferences and automates scheduling workflows | Preferred slots, availability windows, coordination rules | Source for preferred time slots            |
| LeavePlanner | Time Off Management System      | Tracks PTO, holidays, and planned absences                         | Time off records, blackout dates                          | Used for interview availability exclusions |

**Notes:**

- All third-party systems are accessed through internal wrapper services.
- The glossary helps abstract vendor-specific behavior while ensuring a consistent internal data model.
