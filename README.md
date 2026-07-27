# My App - Beginner DevOps Lab 🚀

Welcome! This repository is a simple, clean, and beginner-friendly project designed to help you learn **Docker**, **Kubernetes (Minikube)**, and **GitHub Actions** CI/CD pipelines.

---

## 📂 Project Structure

Here is a quick overview of the files in this project and what they do:

```text
my-app/
│
├── app/                      # The Node.js application code
│   ├── index.js              # The Express web server logic
│   ├── package.json          # Node.js project configuration & dependencies
│   ├── Dockerfile            # Instructions to build the Docker image
│   └── .dockerignore         # Specifies which files Docker should ignore
│
├── k8s/                      # Kubernetes manifests
│   ├── configmap.yaml        # Holds non-sensitive config variables
│   ├── deployment.yaml       # Defines our running application replicas
│   └── service.yaml          # Exposes the pods to network traffic
│
├── .github/                  # GitHub Actions CI/CD workflows
│   └── workflows/
│       ├── ci.yml            # CI workflow: Installs dependencies and builds image
│       └── cd.yml            # CD workflow: Deploys to local Minikube using self-hosted runner
│
├── scripts/                  # Helper automation scripts for local development
│   ├── build.ps1             # PowerShell script to build the Docker image
│   └── deploy.ps1            # PowerShell script to load image and deploy to Minikube
│
├── README.md                 # This guide!
└── .gitignore                # Specifies files that Git should ignore
```

---

## 🛠️ Prerequisites

To run this project on Windows, you need to install:
1. **[Git](https://git-scm.com/)**
2. **[Node.js](https://nodejs.org/)** (LTS version)
3. **[Docker Desktop](https://www.docker.com/products/docker-desktop/)**
4. **[Minikube](https://minikube.sigs.k8s.io/docs/start/)**
5. **[kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/)**

Make sure Docker Desktop is started and running!

---

## 🚀 Step-by-Step Deployment Guide

### 1. Run Node.js App Locally (No Docker)
To verify the app works, install dependencies and start it:
```powershell
cd app
npm install
npm start
```
Now open your browser and navigate to:
- Welcome message: `http://localhost:3000/`
- Health check: `http://localhost:3000/health`

Press `Ctrl + C` in your terminal to stop the server.

---

### 2. Build the Docker Image
Docker lets us package our application and all its dependencies into an "image" that can run anywhere.

Run our helper PowerShell script to build the image:
```powershell
# Go back to the my-app root directory if you are in app/
cd ..
.\scripts\build.ps1
```
Or build it manually using:
```powershell
docker build -t my-app:latest ./app
```

---

### 3. Start Minikube
Minikube runs a single-node Kubernetes cluster inside a virtual machine or container on your local computer.

Start Minikube:
```powershell
minikube start
```

---

### 4. Deploy to Kubernetes (Minikube)
Kubernetes manages containers. We use manifests in `k8s/` to tell Kubernetes how to deploy our app.

Run our deploy helper PowerShell script:
```powershell
.\scripts\deploy.ps1
```
Or run the commands manually:
```powershell
# Load the image into Minikube so it doesn't try to download it from the cloud
minikube image load my-app:latest

# Deploy the configuration, deployment, and service to Kubernetes
kubectl apply -f k8s/

# Wait until deployment is fully ready (all pods are running)
kubectl rollout status deployment/my-app-deployment --timeout=120s
```

---

### 5. Access Your App!
Since Minikube runs inside its own virtualized environment, we cannot immediately type `http://localhost:3000` to access the service. We must ask Minikube to route host traffic to the Service:

```powershell
minikube service my-app-service
```
This command will open your default browser and automatically connect you to the running application in the cluster!

To clean up resources when you are done:
```powershell
kubectl delete -f k8s/
```

---

## 🤖 How the GitHub Actions Pipelines Work

### 🛠️ Continuous Integration (`ci.yml`)
When you push code to GitHub:
1. **Checkout Code**: Downloads your repository onto a GitHub-hosted Linux server.
2. **Setup Node.js**: Prepares the Node environment on the server.
3. **Install Dependencies**: Runs `npm install` inside the `app` folder.
4. **Build Docker Image**: Runs `docker build` to guarantee your code compiles and packages correctly.

### 🚀 Continuous Deployment (`cd.yml`)
Since your Kubernetes cluster is running locally on your computer, GitHub's default cloud servers cannot talk to it. To fix this, we use a **Self-Hosted Runner**:
1. You run a small GitHub agent on your own machine.
2. When you push to the `main` branch, GitHub sends instructions to *your* computer's runner.
3. Your local machine builds the Docker image, loads it into Minikube, and runs `kubectl apply` to deploy.
