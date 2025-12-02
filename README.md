# Flask CI/CD Demo

Minimal Flask app used to practice an end-to-end Jenkins + Docker + Kubernetes pipeline.

## Quickstart (local dev)

1. Build image locally:
   ```bash
   docker build -t flask-cicd-demo:local .
   ```

2. Run locally:
   ```bash
   docker run --rm -p 3000:3000 flask-cicd-demo:local
   ```

3. Smoke test:
   ```bash
   ./app/test.sh
   ```

## Kubernetes (minikube)
- Start minikube:
  ```bash
  minikube start --driver=docker
  eval $(minikube -p minikube docker-env)
  docker build -t flask-cicd-demo:local .
  kubectl apply -f k8s/service.yaml
  kubectl apply -f k8s/deployment.yaml
  kubectl port-forward svc/flask-cicd-demo 8080:80
  ./scripts/integration-test.sh
  ```

## Jenkins
- Add credentials:
  - `dockerhub-creds` (username/password)
  - `kubeconfig` (file)
- Create pipeline job pointing to this repository.
