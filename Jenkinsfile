pipeline {
  agent any

  environment {
    // CHANGE THIS to your real Docker Hub username
    REGISTRY   = "docker.io/YOUR_DOCKERHUB_USER"
    IMAGE_NAME = "flask-cicd-demo"
    // keep TAG simple for now
    TAG        = "${env.BUILD_NUMBER}"
    IMAGE      = "${REGISTRY}/${IMAGE_NAME}:${TAG}"
  }

  stages {

    // This uses the job's GitHub config (Pipeline script from SCM)
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    // Temporarily disabled because Windows Jenkins can't see python/pip yet
    stage('Unit / Smoke Test (local)') {
      when {
        expression { false }  // always skip for now
      }
      steps {
        echo 'Skipping Unit / Smoke Test (local) for now (Python not available on Jenkins Windows).'
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
          """
        }
      }
    }

    // === FUTURE: enable this after we set up kubectl + cluster + kubeconfig ===
    stage('Deploy to Kubernetes') {
      when {
        expression { false } // change to true once K8s is ready
      }
      steps {
        echo "Kubernetes deployment is disabled for now."
        /*
        withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG_FILE')]) {
          bat """
            set KUBECONFIG=%KUBECONFIG_FILE%
            kubectl apply -f k8s\\deployment.yaml
            kubectl apply -f k8s\\service.yaml
          """
        }
        */
      }
    }

    stage('Integration Tests') {
      when {
        expression { false } // enable later
      }
      steps {
        echo "Integration tests are disabled for now (will add after K8s is working)."
        /*
        withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG_FILE')]) {
          bat """
            set KUBECONFIG=%KUBECONFIG_FILE%
            rem Here we would port-forward and call scripts\\integration-test.sh
          """
        }
        */
      }
    }
  }

  post {
    failure {
      echo 'Pipeline failed — review logs.'
    }
    success {
      echo "Pipeline succeeded. Image built and pushed: ${IMAGE}"
    }
  }
}


