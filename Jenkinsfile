pipeline {
  agent any

  environment {
    // TODO: change this to your real Docker Hub username
    REGISTRY   = "docker.io/YOUR_DOCKERHUB_USER"
    IMAGE_NAME = "flask-cicd-demo"
    TAG        = "${env.BUILD_NUMBER}-${(env.GIT_COMMIT ?: 'local').take(7)}"
    IMAGE      = "${REGISTRY}/${IMAGE_NAME}:${TAG}"
  }

  stages {

    stage('Checkout') {
      steps {
        // uses the job's SCM config (GitHub repo you configured)
        checkout scm
      }
    }

    stage('Unit / Smoke Test (local)') {
      steps {
        dir('app') {
          // Windows batch block
          bat '''
            python -m pip install --upgrade pip setuptools
            pip install -r requirements.txt
            rem TODO: add real tests later (pytest, etc.)
          '''
        }
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
        withCredentials([usernamePassword(
          credentialsId: 'dockerhub-creds',
          usernameVariable: 'DOCKER_USER',
          passwordVariable: 'DOCKER_PASS'
        )]) {
          // login + push using Windows cmd
          bat """
            docker login -u %DOCKER_USER% -p %DOCKER_PASS%
            docker push ${IMAGE}
          """
        }
      }
    }

    // --- Kubernetes stages are placeholders for now ---
    // You can enable these later after we:
    // 1) install kubectl on Windows
    // 2) add kubeconfig as a file credential in Jenkins
    // 3) confirm cluster access

    stage('Deploy to Kubernetes') {
      when {
        expression { false }  // <-- change to `true` once k8s is ready
      }
      steps {
        echo "Kubernetes deployment is currently disabled (enable when cluster is ready)."
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
        echo "Integration tests are disabled for now (will use kubectl port-forward + scripts/integration-test.sh)."
        /*
        withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG_FILE')]) {
          bat """
            set KUBECONFIG=%KUBECONFIG_FILE%
            rem Example: run integration tests after port-forwarding service
            rem kubectl get pods -l app=flask-cicd-demo
            rem kubectl port-forward <pod-name> 8080:3000
            rem call scripts\\integration-test.sh (would need bash or WSL)
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

