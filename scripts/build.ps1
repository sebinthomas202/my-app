# build.ps1 - PowerShell script to build the Docker image locally.
# This script is beginner-friendly and demonstrates how to automate building Docker images.

# Set error action to stop script execution on error
$ErrorActionPreference = "Stop"

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Step 1: Building the Docker image locally" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

# Define variables
$ImageName = "my-app"
$ImageTag = "latest"
$DockerfilePath = "./app/Dockerfile"
$BuildContext = "./app"

# Check if docker is running
try {
    docker info > $null
} catch {
    Write-Error "Docker is not running! Please start Docker Desktop first."
}

# Run the docker build command
Write-Host "Running: docker build -t ${ImageName}:${ImageTag} -f $DockerfilePath $BuildContext" -ForegroundColor Yellow
docker build -t "${ImageName}:${ImageTag}" -f $DockerfilePath $BuildContext

Write-Host ""
Write-Host "Success: Docker image '${ImageName}:${ImageTag}' built successfully!" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Cyan
