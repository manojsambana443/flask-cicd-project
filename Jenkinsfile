pipeline {
  agent any
  environment {
    REGISTRY = "docker.io/your-dockerhub-user"
    IMAGE_NAME = "flask-cicd-demo"
    TAG = "${env.BUILD_NUMBER}-${env.GIT_COMMIT.take(7)}"
    IMAGE = "${env.REGISTRY}/${env.IMAGE_NAME}:${env.TAG}"
  }
  stages {
    stage('Checkout') {
      steps { checkout scm }
    }
    stage('Unit / Smoke Test (local)') {
      steps {
        dir('app') {
          sh 'python -m pip install --upgrade pip setuptools'
          sh 'pip install -r requirements.txt'
          // run tests if any (here we keep smoke script for local run)
        }
      }
    }
    stage('Build Docker Image') {
      steps {
        script {
          sh "docker build -t ${IMAGE} ."
        }
      }
    }
    stage('Push Image') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
          sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
          sh "docker push ${IMAGE}"
        }
      }
    }
    stage('Deploy to Kubernetes') {
      steps {
        withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
          sh "kubectl set image -f k8s/deployment.yaml app=${IMAGE} --record || kubectl apply -f k8s/deployment.yaml"
          sh "kubectl apply -f k8s/service.yaml"
        }
      }
    }
    stage('Integration Tests') {
      steps {
        withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
          sh "kubectl rollout status deployment/flask-cicd-demo --timeout=120s"
          sh "kubectl get pods -l app=flask-cicd-demo -o jsonpath='{.items[0].metadata.name}' > /tmp/podname"
          sh 'kubectl port-forward $(cat /tmp/podname) 8080:3000 & sleep 3'
          sh "BASE_URL=http://127.0.0.1:8080 ./scripts/integration-test.sh"
        }
      }
    }
  }
  post {
    failure {
      echo 'Pipeline failed — review logs and consider rollback'
    }
    success {
      echo "Pipeline succeeded: ${IMAGE}"
    }
  }
}
