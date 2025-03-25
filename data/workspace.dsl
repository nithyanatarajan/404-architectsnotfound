workspace {

    model {
        recruiter = person "Recruiter" {
            description "Schedules interviews, interacts with chatbot, monitors status, and uses dashboard"
            tags "Person"
        }

        candidate = person "Candidate" {
            description "Selects interview slot from scheduling link"
            tags "Person"
        }

        interviewer = person "Interviewer" {
            description "Conducts interviews, responds via calendar or chat"
            tags "Person"
        }

        // External systems
        interviewLogger = softwareSystem "InterviewLogger" {
            description "ATS used for tracking candidates and interview feedback."
            tags "ExternalSystem"
        }

        mindComputeScheduler = softwareSystem "MindComputeScheduler" {
            description "Tool to generate scheduling links and manage interviewer preferences."
            tags "ExternalSystem"
        }

        myMindComputeProfile = softwareSystem "MyMindComputeProfile" {
            description "Internal directory with interviewer skills/preferences"
            tags "ExternalSystem"
        }

        leavePlanner = softwareSystem "LeavePlanner" {
            description "Manages interviewer leave data"
            tags "ExternalSystem"
        }

        messenger = softwareSystem "Messenger" {
            description "Chatbot interface and scheduling notifications"
            tags "ExternalSystem"
        }

        calendar = softwareSystem "Calendar" {
            description "Used to verify interviewer availability and send invites"
            tags "ExternalSystem"
        }

        recruitx = softwareSystem "RecruitX Platform" {
            description "Recruitment platform to match, schedule, notify, and track interviews"
            tags "CoreSystem"

            chatbot = container "Chatbot Service" {
                technology "Python + FastAPI + LangChain"
                description "Conversational interface for recruiters to query interviewer availability, initiate scheduling, and get updates"
                tags "InternalSystem"
            }

            dashboard = container "Dashboard Service" {
                technology "Flutter"
                description "Web UI to view status, reports, initiate interviews"
                tags "InternalSystem"
            }

            profileService = container "Interviewer Profile Service" {
                technology "Python + FastAPI + Redis"
                description "Fetches and serves interviewer metadata (skills, grade, timezone)"
                tags "InternalSystem"
            }

            candidateService = container "Candidate Insights Service" {
                technology "Python + FastAPI + Redis"
                description "Fetches and serves candidate profiles and preferences"
                tags "InternalSystem"
            }

            preferencesService = container "Interviewer Preferences Service" {
                technology "Python + FastAPI + Redis"
                description "Manages interviewer's availability preferences, block/savelist logic"
                tags "InternalSystem"
            }

            configService = container "Scheduling Config Service" {
                technology "Python + FastAPI + Redis"
                description "Manages matcher dimension weights, processing logic, and runtime overrides"
                tags "InternalSystem"
            }

            configStore = container "Config Storage" {
                technology "PostgreSQL"
                description "Stores dimension information along with weights"
                tags "Cache"
            }

            availabilityService = container "Availability Evaluator Service" {
                technology "Go + Fiber + Calendar API"
                description "Evaluates slot-level availability using Calendar and LeavePlanner"
                tags "InternalSystem"
            }

            matcher = container "Matcher & Selector Service" {
                technology "Go + Fiber + Redis"
                description "Scores and ranks best-fit interviewers for a candidate based on multiple dimensions"
                tags "InternalSystem"
            }

            slotSuggester = container "Slot Recommender Service" {
                technology "Go + Fiber"
                description "Suggests optimal interview time slots based on preferences and availability"
                tags "InternalSystem"
            }

            scheduler = container "Interview Scheduler Service" {
                technology "Go + Fiber"
                description "Schedules interview"
                tags "InternalSystem"
            }

            reportingService = container "Reporting & Analytics Service" {
                technology "Python + FastAPI + ETL + PostgreSQL + Grafana"
                description "Runs ETL, generates analytics dashboards, metrics and history reports"
                tags "InternalSystem"
            }

            eventBus = container "Event Bus" {
                technology "Kafka / PubSub"
                description "Internal event streaming backbone used by microservices for pub/sub"
                tags "InternalInfra"
            }

            authGateway = container "Auth Gateway" {
                technology "OIDC + Kong Gateway + OPA"
                description "Handles authentication (Okta SSO), routes and enforces RBAC via External OPA"
                tags "InternalSystem"
            }
        }

        // Internal infrastructure
        eventBusBroker = softwareSystem "Event Bus (Kafka / PubSub)" {
            description "Internal event broker for microservices"
            tags "InternalInfra"
        }
        //------------------------C1------------------------//
        // C1:Flows to internal systems
        recruitx -> eventBusBroker "Publishes and Subscribes to events" {
            tags "InternalFlow"
        }

        // C1:Flows to external systems
        recruitx -> interviewLogger "Fetches candidate status and updates interview" {
            tags "ExternalFlow"
        }
        recruitx -> mindComputeScheduler "Generates scheduling link, receives callbacks" {
            tags "ExternalFlow"
        }
        recruitx -> myMindComputeProfile "Fetches interviewer profiles" {
            tags "ExternalFlow"
        }
        recruitx -> leavePlanner "Fetches leave data" {
            tags "ExternalFlow"
        }
        recruitx -> messenger "Sends chat messages, receives chatbot queries" {
            tags "ExternalFlow"
        }
        recruitx -> calendar "Sends invites, receives RSVP updates" {
            tags "ExternalFlow"
        }

        // C1: User interaction
        recruiter -> recruitx "Schedules interviews and views reports" {
            tags "InternalFlow"
        }
        recruitx -> recruiter "Sends updates, dashboards, reports" {
            tags "InternalFlow"
        }
        candidate -> recruitx "Selects slot via MindComputeScheduler (callback flow)" {
            tags "ExternalFlow"
        }
        recruitx -> interviewer "Sends calendar invites and notifications" {
            tags "InternalFlow"
        }
        interviewer -> recruitx "RSVPs via calendar or chat" {
            tags "ExternalFlow"
        }
        //------------------------C1------------------------//


        //------------------------C2------------------------//

        // External integrations
        profileService -> myMindComputeProfile "Fetches interviewer data"

        candidateService -> interviewLogger "Fetches candidate profile"

        preferencesService -> mindComputeScheduler "Fetches round/time preferences"

        configService -> configStore "Read and updates config dimensions"

        availabilityService -> calendar "Reads calendar, sends invites"
        availabilityService -> leavePlanner "Reads leave data"

        // User journey
        recruiter -> chatbot "Asks for availability, initiates scheduling"
        recruiter -> dashboard "Asks for availability, initiates scheduling, manages and tracks interviews"

        chatbot -> matcher "Requests interviewer suggestions"
        chatbot -> slotSuggester "Fetches slot suggestions"
        chatbot -> scheduler "Schedule interview"

        dashboard -> matcher "Requests best interviewer matches"
        dashboard -> slotSuggester "Fetches available slots"
        dashboard -> scheduler "Schedule interview"

        scheduler -> matcher "Gets top interviewer based on timeslot"

        matcher -> configService "Fetches matcher config"
        matcher -> profileService "Fetches interviewer profile"
        matcher -> candidateService "Fetches candidate profile"
        matcher -> availabilityService "Checks availability"

        availabilityService -> preferencesService "Uses block/savelist"

        slotSuggester -> matcher "Gets top interviewers"

        matcher -> eventBus "Publishes match suggestions"
        slotSuggester -> eventBus "Publishes slot recommendations"

        eventBus -> dashboard "Subscribes to match suggestions"
        eventBus -> dashboard "Subscribes to slot recommendations"

        eventBus -> chatbot "Subscribes to match suggestions"
        eventBus -> chatbot "Subscribes to slot recommendations"

        reportingService -> eventBus "Publishes reports generated"
        eventBus -> reportingService "Consumes system events"
        chatbot -> eventBus "Publishes query/request events"
        dashboard -> eventBus "Publishes user actions"

        eventBus -> messenger "Sends reports/alerts"

        interviewer -> chatbot "Asks for interview details for self"

        chatbot -> messenger "Receives chat queries"

        dashboard -> interviewLogger "Updates interview records"
    }

    views {
        systemContext recruitx {
            include *
            title "RecruitX - System Context"
        }

        container recruitx {
            include *
            autolayout tb
            title "RecruitX Platform – Container View (Python + Go Hybrid)"
        }

        styles {
            element "Person" {
                shape person
                background #0D47A1
                color #ffffff
                fontSize 30
            }

            element "CoreSystem" {
                shape roundedbox
                background #1565C0
                color #ffffff
                fontSize 30
            }

            element "ExternalSystem" {
                shape roundedbox
                background #E1BEE7
                color #000000
                fontSize 30
            }

            element "InternalInfra" {
                shape pipe
                background #ECEFF1
                color #000000
                fontSize 30
            }

            element "Cache" {
                shape pipe
                background #87CEEB
                color #000000
                fontSize 30
            }

            element "InternalSystem" {
                shape roundedbox
                background #1565C0
                color #000000
                fontSize 30
            }

            element "Container" {
                shape roundedbox
                background #D8EBFF
                color #000000
            }

            relationship "InternalFlow" {
                color #1976D2
                thickness 3
                style solid
                fontSize 26
            }

            relationship "ExternalFlow" {
                color #9C27B0
                thickness 2
                style dashed
                fontSize 26
            }
        }
    }
}
