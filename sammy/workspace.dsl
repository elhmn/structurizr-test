workspace {

    model {
        user = person "User" "A Software Developer, trying to deploy his application"
        ciSystem = softwareSystem "CI" "CI jobs setup on a GitHub repository" {
            tags "ci"
        }

        infrastructure = softwareSystem "Infrastructure" "Where the applications are deployed and run" {
            tags "infrastructure"

            deploymentRepoContainer = container "Deployment Repository" "Contains application's deploy manifests" "GitHub repository" {
                tags "githubRepository, github"
            }

            webhookContainer = container "Webhook instance" "Application waiting for http call, and execute commands on your VPS" {
                tags "webhook"
            }

            swarmContainer = container "Swarm clusters" "The Swarm infrastructure our application are deployed to" {
                tags "swarm"
            }
        }

        artifactManagmentSystem = softwareSystem "Artifact Management System" "The system responsible for creating and managing our artifacts" {
            ciArtifactCreatorContainer = container "CI Artifact Creator" "Creates an artifact, ex: docker images, static files, modules" "GitHub Action" {
                tags "github"
            }

            ciArtifactRegisterContainer = container "CI Artifact Register" "Register the generated artifact in the system" "GitHub Action" {
                tags "github"
            }

            ciDeploymentRequestContainer = container "CI Deployment Request" "Request the deployment of an artifacts to a staging environment" "GitHub Action" {
                tags "github"
            }

            uiContainer = container "Web UI artifact visualiser" "Web interface to see a list of artifact and request their deployment on specific environments"{
                tags "webui"
            }

            apiContainer = container "API" "Store and Get artifact's metadata and events. Trigger artifacts deployment" {
                tags "api"
            }

            artifactRegistryContainer = container "Artifact Registry" "A place to store our artifacts" "ECR | GCR | Artifactory"
            storageContainer = container "Storage" {
                tags "storage"
            }
        }

//artifactManagmentSystem containers relationships
        ciArtifactCreatorContainer -> artifactRegistryContainer "Pushes artifact to"
        ciArtifactRegisterContainer -> apiContainer "Makes API Calls to" "JSON/HTTPS"
        ciDeploymentRequestContainer -> apiContainer "Makes API Calls to" "JSON/HTTPS"
        uiContainer -> apiContainer "Makes API Calls to" "JSON/HTTPS"
        apiContainer -> deploymentRepoContainer "Trigger deployment" "JSON/HTTPS"
        apiContainer -> storageContainer "Store and Get artifact metadata"
        swarmContainer -> artifactRegistryContainer "Pull artifact metadata from"

        ciSystem -> ciArtifactRegisterContainer "Sends artifact metadata"
        ciSystem -> ciDeploymentRequestContainer "Request deployment"
        ciSystem -> ciArtifactCreatorContainer "Create artifact"
        user -> uiContainer "Request deployment"


        deploymentRepoContainer -> webhookContainer "Request a deployment" "JSON/HTTPS"
        webhookContainer -> swarmContainer "Deploy applications to"
    }

    views {
        systemContext artifactManagmentSystem "AMS-Context" {
            include *
            autoLayout lr
        }

        container artifactManagmentSystem "AMS-Containers" {
            include *
            autoLayout lr
        }

        container infrastructure "Infrastructure" {
            include *
        }

        styles {

            element "Software System" {
                shape Box
                Background #eeeeee
                color #000000
            }

            element "Person" {
                Background #cccccc
                color #000000
            }

            element Container {
                Background #ffffff
                Colour #707070
            }

            element webui {
                shape WebBrowser
            }

            element storage {
                shape Cylinder
            }

            element swarm {
                icon "https://img.icons8.com/color/50/000000/docker.png"
            }

            element webhook {
                icon "https://img.icons8.com/color/48/000000/webhook.png"
            }

           element githubRepository {
               shape Folder
                icon "https://img.icons8.com/ios-glyphs/30/000000/github.png"
            }

            element github {
                icon "https://img.icons8.com/ios-glyphs/30/000000/github.png"
            }

            element infrastructure {
                icon "https://img.icons8.com/external-xnimrodx-blue-xnimrodx/64/000000/external-server-online-marketing-xnimrodx-blue-xnimrodx-2.png"
            }

            element ci {
                icon "https://img.icons8.com/ios-filled/50/4a90e2/circuit.png"
            }
        }

        theme default

}
