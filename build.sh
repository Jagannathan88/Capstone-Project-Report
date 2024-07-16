#!/bin/bash
echo "Enter docker image name:"
read IMAGE_NAME
echo "Enter docker image tag:"
read TAG
echo "Building docker image $IMAGE_NAME:$TAG"
docker build -t "$IMAGE_NAME:$TAG" .
if [ $? -eq 0 ]; then
        echo "Docker image built successfully: $IMAGE_NAME:$TAG"
else
        echo "Docker image build failed"
        exit 1
fi

