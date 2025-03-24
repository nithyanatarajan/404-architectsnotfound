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
            }

            dashboard = container "Dashboard Service" {
                technology "Flutter + REST API"
                description "Web UI to view status, reports, initiate interviews"
            }

            profileService = container "Interviewer Profile Service" {
                technology "Python + FastAPI + Redis"
                description "Fetches and serves interviewer metadata (skills, grade, timezone)"
            }

            candidateService = container "Candidate Insights Service" {
                technology "Python + FastAPI + Redis"
                description "Fetches and serves candidate profiles and preferences"
            }

            preferencesService = container "Interviewer Preferences Service" {
                technology "Python + FastAPI + Redis"
                description "Manages interviewer's availability preferences, block/savelist logic"
            }

            availabilityService = container "Availability Evaluator Service" {
                technology "Go + Fiber + Calendar API"
                description "Evaluates slot-level availability using Calendar and LeavePlanner"
            }

            configService = container "Scheduling Config Service" {
                technology "Python + FastAPI + PostgreSQL"
                description "Manages matcher dimension weights, processing logic, and runtime overrides"
            }

            matcher = container "Matcher & Selector Service" {
                technology "Go + Fiber + Redis"
                description "Scores and ranks best-fit interviewers for a candidate based on multiple dimensions"
            }

            slotSuggester = container "Slot Recommender Service" {
                technology "Go + Fiber"
                description "Suggests optimal interview time slots based on preferences and availability"
            }

            reportingService = container "Reporting & Analytics Service" {
                technology "Python + FastAPI + ETL + PostgreSQL + Grafana"
                description "Runs ETL, generates analytics dashboards, metrics and history reports"
            }

            //            eventBus = container "Event Bus" {
            //                technology "Go + Kafka / Google PubSub Client"
            //                description "Microservice communication and domain event flow"
            //            }

            authGateway = container "Auth Gateway" {
                technology "Go + OIDC + API Gateway"
                description "Handles authentication (Okta SSO), routes and enforces RBAC"
            }

            recruiter -> this "Schedules interviews and views reports" {
                tags "InternalFlow"
            }
            this -> recruiter "Sends updates, dashboards, reports" {
                tags "InternalFlow"
            }
            candidate -> this "Selects slot via MindComputeScheduler (callback flow)" {
                tags "ExternalFlow"
            }
            this -> interviewer "Sends calendar invites and notifications" {
                tags "InternalFlow"
            }
            interviewer -> this "RSVPs via calendar or chat" {
                tags "ExternalFlow"
            }
        }

        // Internal infrastructure
        eventBus = softwareSystem "Event Bus (Kafka / PubSub)" {
            description "Internal event broker for microservices"
            tags "InternalInfra"
            recruitx -> this "Publishes and consumes events" {
                tags "InternalFlow"
            }
        }

        // Flows to external systems
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


        // External integrations
        profileService -> myMindComputeProfile "Fetches interviewer data"
        candidateService -> interviewLogger "Fetches candidate profile"
        preferencesService -> mindComputeScheduler "Fetches round/time preferences"
        dashboard -> interviewLogger "Updates interview records"
        reportingService -> messenger "Sends reports/alerts"
        availabilityService -> calendar "Reads calendar, sends invites"
        availabilityService -> leavePlanner "Reads leave data"
        chatbot -> messenger "Receives chat queries"

        // Internal interactions
        recruiter -> chatbot "Asks for availability, initiates scheduling"
        recruiter -> dashboard "Manages and tracks interviews"
        dashboard -> matcher "Requests best interviewer matches"
        dashboard -> slotSuggester "Fetches available slots"

        chatbot -> matcher "Requests interviewer suggestions"
        chatbot -> slotSuggester "Fetches slot suggestions"
        chatbot -> availabilityService "Confirms availability"

        matcher -> configService "Fetches matcher config"
        matcher -> profileService "Fetches interviewer profile"
        matcher -> candidateService "Fetches candidate profile"
        matcher -> preferencesService "Fetches preferences"
        matcher -> availabilityService "Checks availability"

        slotSuggester -> matcher "Gets top interviewers"
        slotSuggester -> availabilityService "Fetches slots"
        slotSuggester -> preferencesService "Applies preference filters"

        availabilityService -> preferencesService "Uses block/savelist"
        availabilityService -> calendar "Uses Calendar API"
        availabilityService -> leavePlanner "Checks leave status"

        reportingService -> eventBus "Consumes system events"
        chatbot -> eventBus "Publishes query/request events"
        dashboard -> eventBus "Publishes user actions"
        matcher -> eventBus "Publishes match suggestions"
        slotSuggester -> eventBus "Publishes slot recommendations"
        availabilityService -> eventBus "Publishes availability status"
        preferencesService -> eventBus "Publishes preference changes"
        profileService -> eventBus "Publishes profile updates"
        reportingService -> eventBus "Publishes reports generated"
        //        authGateway -> allContainers "Enforces auth & routes"
    }

    views {
        systemContext recruitx {
            include *
            title "RecruitX - System Context"
        }

        container recruitx {
            include *
            autolayout lr
            title "RecruitX Platform – Container View (Python + Go Hybrid)"
        }

        styles {
            element "Person" {
                shape person
                background #0D47A1
                color #ffffff
                fontSize 18
            }

            element "CoreSystem" {
                shape roundedbox
                background #1565C0
                color #ffffff
                fontSize 18
            }

            element "ExternalSystem" {
                shape roundedbox
                background #E1BEE7
                color #000000
                fontSize 16
            }

            element "InternalInfra" {
                shape roundedbox
                background #C0D9FF
                color #000000
                fontSize 16
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
                fontSize 14
            }

            relationship "ExternalFlow" {
                color #9C27B0
                thickness 2
                style dashed
                fontSize 13
            }
        }
    }
}
