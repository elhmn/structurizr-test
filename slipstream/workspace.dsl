workspace {

    model {
        user = person "User" "A Software Developer, trying to deploy his application"
        ciSystem = softwareSystem "CI" "CI jobs setup on a GitHub repository" {
            tags "githubRepository, github"
        }

        infrastructure = softwareSystem "Infrastructure" "Where the applications are deployed and run" {
            tags "infrastructure"

            deploymentRepoContainer = container "Deployment Repository" "Contains application's deploy manifests" "GitHub repository" {
                tags "githubRepository, github"
            }

            argoCDContainer = container "ArgoCD" "Application that syncs your deployment manifest in the k8s clusters" {
                tags "argoCD"
            }

            k8sContainer = container "K8S clusters" "The K8S infrastructure our application are deployed to" {
                tags "k8s"
            }
        }

        artifactManagmentSystem = softwareSystem "Artifact Management System" "The system responsible for creating and managing our artifacts" {
            ciArtifactCreatorContainer = container "CI Artifact Creator" "Creates an artifact, ex: docker images, static files, modules" "GitHub Action" {
                tags "github, jobRunner"
            }

            ciArtifactRegisterContainer = container "CI Artifact Register" "Register the generated artifact in the system" "GitHub Action" {
                tags "github, jobRunner"
            }

            ciDeploymentRequestContainer = container "CI Deployment Request" "Request the deployment of an artifacts to a staging environment" "GitHub Action" {
                tags "github, jobRunner"
            }

            uiContainer = container "Web UI artifact visualiser" "Web interface to see a list of artifact and request their deployment on specific environments"{
                tags "webui"
            }

            cliContainer = container "CLI artifact visualiser" "CLI interface to see a list of artifact and request their deployment on specific environments"{
                tags "cli"
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
        cliContainer -> apiContainer "Makes API Calls to" "JSON/HTTPS"
        apiContainer -> deploymentRepoContainer "Trigger deployment" "JSON/HTTPS"
        apiContainer -> storageContainer "Store and Get artifact metadata"
        k8sContainer -> artifactRegistryContainer "Pull artifact metadata from"

        ciSystem -> ciArtifactCreatorContainer "Create artifact"
        ciSystem -> ciDeploymentRequestContainer "Request deployment"
        ciSystem -> ciArtifactRegisterContainer "Sends artifact metadata"
        user -> uiContainer "Request deployment"
        user -> cliContainer "Request deployment"


        deploymentRepoContainer -> argoCDContainer "Request a deployment" "JSON/HTTPS"
        argoCDContainer -> k8sContainer "Deploy applications to"
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
                icon "https://img.icons8.com/external-tal-revivo-shadow-tal-revivo/24/000000/external-elasticsearch-a-search-engine-based-on-the-lucene-library-logo-shadow-tal-revivo.png"
            }

            element k8s {
                icon "https://img.icons8.com/color/48/000000/kubernetes.png"
            }

            element argoCD {
                icon "https://cncf-branding.netlify.app/img/projects/argo/icon/color/argo-icon-color.png"
            }

           element githubRepository {
               shape Folder
            }

            element github {
                icon "https://img.icons8.com/ios-glyphs/30/000000/github.png"
            }

            element infrastructure {
                icon "https://img.icons8.com/external-xnimrodx-blue-xnimrodx/64/000000/external-server-online-marketing-xnimrodx-blue-xnimrodx-2.png"
            }

            element ci-old {
                icon "https://img.icons8.com/ios-filled/50/4a90e2/circuit.png"
            }


            element jobRunner {
                shape Hexagon
            }


        }

        theme default

}
