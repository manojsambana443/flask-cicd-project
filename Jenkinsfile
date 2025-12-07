pipeline {
  agent any

  environment {
    // Docker Hub registry and image info
    REGISTRY   = "docker.io/smk135"
    IMAGE_NAME = "flask-cicd-demo"

    // Use Jenkins build number as tag (13, 14, etc.)
    TAG        = "${env.BUILD_NUMBER}"
    IMAGE      = "${REGISTRY}/${IMAGE_NAME}:${TAG}"
  }

  stages {

    stage('Checkout') {
      steps {
        // Uses the job's SCM (your GitHub repo configured in Jenkins)
        checkout scm
      }
    }

    // 🔹 Python smoke tests disabled for now (no Python on Jenkins Windows)
    stage('Unit / Smoke Test (local)') {
      when {
        expression { false } // always skip for now
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
        echo 'Deploying to Kubernetes cluster...'
        // Assumes kubectl is on PATH and docker-desktop context exists
        bat """
          kubectl config use-context docker-desktop
          kubectl apply -f k8s
        """
      }
    }

    // 🔹 Integration tests disabled for now (we can add later)
    stage('Integration Tests') {
      when {
        expression { false } // enable later
      }
      steps {
        echo 'Integration tests are disabled for now.'
      }
    }
  }

  post {
    success {
      echo "Pipeline succeeded. Image built and pushed: ${IMAGE}"
    }
    failure {
      echo 'Pipeline failed — review logs.'
    }
  }
}



