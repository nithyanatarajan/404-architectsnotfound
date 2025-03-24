workspace {

    model {
        user = person "Recruiter" {
            description "Schedules interviews and interacts with the chatbot."
            tags "Person"
        }

        candidate = person "Candidate" {
            description "Selects interview slot from scheduling link."
            tags "Person"
        }

        interviewer = person "Interviewer" {
            description "Conducts interviews, interacts with the chatbot and receives notifications."
            tags "Person"
        }

        interviewLogger = softwareSystem "InterviewLogger" {
            description "ATS used for tracking candidates and interview feedback."
            tags "ExternalSystem"
        }

        mindComputeScheduler = softwareSystem "MindComputeScheduler" {
            description "Tool to generate scheduling links and manage interviewer preferences."
            tags "ExternalSystem"
        }

        myMindComputeProfile = softwareSystem "MyMindComputeProfile" {
            description "Stores interviewer skills and preferences."
            tags "ExternalSystem"
        }

        leavePlanner = softwareSystem "LeavePlanner" {
            description "Stores interviewer leave data."
            tags "ExternalSystem"
        }

        messenger = softwareSystem "Messenger" {
            description "Used for chatbot interaction and notifications."
            tags "ExternalSystem"
        }

        calendar = softwareSystem "Calendar" {
            description "Used for verifying interviewer availability."
            tags "ExternalSystem"
        }

        system = softwareSystem "RecruitX" {
            description "Recruitment app to match, schedule, notify, and track interviews."
            tags "CoreSystem"

            user -> this "Initiates scheduling via InterviewLogger" {
                tags "InternalFlow"
            }

            this -> user "Shows dashboard and reports" {
                tags "InternalFlow"
            }

            this -> candidate "Sends scheduling links" {
                tags "ExternalFlow"
            }

            this -> interviewer "Sends calendar invites and notifications" {
                tags "InternalFlow"
            }

            this -> interviewLogger "Fetches candidate status & updates interview feedback" {
                tags "ExternalFlow"
            }

            this -> mindComputeScheduler "Retrieves interview preferences and available slots" {
                tags "ExternalFlow"
            }

            this -> myMindComputeProfile "Fetches interviewer skills" {
                tags "ExternalFlow"
            }

            this -> leavePlanner "Checks leave conflicts" {
                tags "ExternalFlow"
            }

            this -> messenger "Sends notifications and chatbot replies" {
                tags "ExternalFlow"
            }

            this -> calendar "Verifies interviewer availability" {
                tags "ExternalFlow"
            }
        }
    }

    views {
        systemContext system {
            include *
            autolayout tb
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
