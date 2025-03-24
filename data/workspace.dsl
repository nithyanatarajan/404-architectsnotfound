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
    }

    views {
        systemContext recruitx {
            include *
            title "RecruitX - System Context"
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
