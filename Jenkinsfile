pipeline {
  agent any

  environment {
    // Docker Hub image info
    REGISTRY   = "docker.io/smk135"
    IMAGE_NAME = "flask-cicd-demo"
    TAG        = "${env.BUILD_NUMBER}"
    IMAGE      = "${REGISTRY}/${IMAGE_NAME}:${TAG}"

    // kubectl path from: Get-Command kubectl | Select-Object Source
    KUBECTL = "C:\\Program Files\\Docker\\Docker\\resources\\bin\\kubectl.exe"
  }

  stages {

    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    // still skipped for now
    stage('Unit / Smoke Test (local)') {
      when {
        expression { false }
      }
      steps {
        echo 'Skipping Unit / Smoke Test (local) (Python not wired on Jenkins yet).'
      }
    }

    stage('Build Docker Image') {
      steps {
        echo "Building Docker image: ${IMAGE}"
        bat "docker build -t ${IMAGE} ."
      }
    }

    stage('Push Image') {
      steps {
        withCredentials([
          usernamePassword(
            credentialsId: 'dockerhub-creds',
            usernameVariable: 'DOCKER_USER',
            passwordVariable: 'DOCKER_PASS'
          )
        ]) {
          bat """
            docker login -u %DOCKER_USER% -p %DOCKER_PASS%
            docker push ${IMAGE}
            docker logout
          """
        }
      }
    }

    stage('Deploy to Kubernetes') {
      steps {
        echo 'Deploying to Kubernetes cluster from Jenkins...'
        bat """
          "%KUBECTL%" config use-context docker-desktop
          "%KUBECTL%" apply -f k8s
        """
      }
    }

    stage('Integration Tests') {
      when {
        expression { false }
      }
      steps {
        echo 'Integration tests are disabled for now.'
      }
    }
  }

  post {
    success {
      echo "Pipeline succeeded. Image built, pushed, and deployed: ${IMAGE}"
    }
    failure {
      echo 'Pipeline failed — review logs.'
    }
  }
}




