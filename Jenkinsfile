pipeline {
    agent any

    // Global environment for the pipeline
    environment {
        // Docker image name (tagged with Jenkins build number)
        IMAGE_NAME = "docker.io/smk135/flask-cicd-demo:${BUILD_NUMBER}"

        // Kubeconfig path for Jenkins service user
        KUBECONFIG = 'C:\\ProgramData\\Jenkins\\.kube\\config'

        // kubectl path from Docker Desktop installation
        KUBECTL    = 'C:\\Program Files\\Docker\\Docker\\resources\\bin\\kubectl.exe'
    }

    options {
        // Avoid double checkout (we manage checkout ourselves)
        skipDefaultCheckout()
    }

    stages {

        stage('Checkout') {
            steps {
                echo "Checking out source code from Git..."
                checkout scm
            }
        }

        stage('Unit / Smoke Test (local)') {
            when {
                // Keep this false for now so it doesn't block your pipeline
                expression { return false }
            }
            steps {
                echo "Here you can run pytest or simple curl-based smoke tests."
                // Example (uncomment when you actually add tests):
                // bat 'python -m pytest'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image: ${IMAGE_NAME}"
                bat """
                docker version
                docker build -t ${IMAGE_NAME} .
                """
            }
        }

        stage('Push Image') {
            steps {
                // Replace 'dockerhub-creds' with your actual Jenkins credential ID
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub-creds',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )
                ]) {
                    echo "Logging in to Docker Hub and pushing image..."
                    bat """
                    docker login -u %DOCKER_USER% -p %DOCKER_PASS%
                    docker push ${IMAGE_NAME}
                    docker logout
                    """
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                echo "Deploying to Kubernetes cluster from Jenkins..."
                bat """
                echo Using KUBECONFIG=%KUBECONFIG%

                "%KUBECTL%" config get-contexts

                REM If docker-desktop context exists, switch to it (ignore error if not)
                "%KUBECTL%" config use-context docker-desktop || echo Context 'docker-desktop' not switched (might already be current).

                "%KUBECTL%" get nodes

                REM Apply all manifests in k8s folder
                "%KUBECTL%" apply -f k8s
                """
            }
        }

        stage('Integration Tests') {
            when {
                expression { return false }  // enable later when you add tests
            }
            steps {
                echo "Run post-deploy integration tests here (curl the service, etc.)."
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully ✅"
        }
        failure {
            echo "Pipeline failed — review logs ❌"
        }
    }
}





