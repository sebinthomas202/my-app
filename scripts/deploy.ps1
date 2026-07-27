# deploy.ps1 - PowerShell script to deploy the application to local Minikube cluster.
# This script is beginner-friendly and automates loading the image and applying Kubernetes manifests.

# Set error action to stop script execution on error
$ErrorActionPreference = "Stop"

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Step 2: Deploying to Minikube Cluster" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

# Define variables
$ImageName = "my-app"
$ImageTag = "latest"
$ManifestsPath = "./k8s"
$DeploymentName = "my-app-deployment"

# 1. Check if Minikube is running
Write-Host "Checking Minikube cluster status..." -ForegroundColor Yellow
$MinikubeStatus = minikube status --format "{{.Host}}"
if ($MinikubeStatus -ne "Running") {
    Write-Error "Minikube is not running! Please run 'minikube start' first."
}
Write-Host "Minikube is running." -ForegroundColor Green

# 2. Load the Docker image into Minikube
Write-Host "Loading Docker image '${ImageName}:${ImageTag}' into Minikube..." -ForegroundColor Yellow
minikube image load "${ImageName}:${ImageTag}"
Write-Host "Image successfully loaded into Minikube." -ForegroundColor Green

# 3. Apply Kubernetes manifests
Write-Host "Applying Kubernetes manifests from '$ManifestsPath'..." -ForegroundColor Yellow
kubectl apply -f $ManifestsPath

# 4. Wait for Deployment to roll out and verify status
Write-Host "Waiting for deployment rollout to complete..." -ForegroundColor Yellow
kubectl rollout status "deployment/$DeploymentName" --timeout=120s

# Get NodePort service URL
Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Deployment completed successfully!" -ForegroundColor Green
Write-Host "You can access your service using the command:" -ForegroundColor Yellow
Write-Host "  minikube service my-app-service" -ForegroundColor Magenta
Write-Host "==========================================" -ForegroundColor Cyan
