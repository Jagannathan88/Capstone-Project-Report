#!/bin/bash

# Prompt for Docker image name and tag
echo "Enter the Docker image name:"
read IMAGE_NAME
echo "Enter the Docker image tag:"
read TAG
echo "Enter your Docker Hub username:"
read DOCKER_USERNAME
echo "Enter your Docker Hub repository name:"
read DOCKER_REPO

# Build the Docker image
echo "Building Docker image..."
docker build -t "$IMAGE_NAME:$TAG" .

# Check if the build was successful
if [ $? -eq 0 ]; then
    echo "Docker image built successfully: $IMAGE_NAME:$TAG"
else
    echo "Docker image build failed"
    exit 1
fi

# Tag the Docker image
echo "Tagging Docker image..."
docker tag "$IMAGE_NAME:$TAG" "$DOCKER_USERNAME/$DOCKER_REPO:$TAG"

# Push the Docker image to Docker Hub
echo "Pushing Docker image to Docker Hub..."
docker push "$DOCKER_USERNAME/$DOCKER_REPO:$TAG"

# Check if the push was successful
if [ $? -eq 0 ]; then
    echo "Docker image pushed successfully to Docker Hub: $DOCKER_USERNAME/$DOCKER_REPO:$TAG"
else
    echo "Docker image push failed"
    exit 1
fi

