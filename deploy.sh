#!/bin/bash
echo "Enter the docker image name:"
read IMAGE_NAME
echo "Enter the docker image tag:"
read TAG
echo "enter the container name:"
read CONTAINER_NAME
# Check if a container with the same name is already running and stop it
if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
        echo "Stopping existing container: $CONTAINER_NAME"
        docker stop $CONTAINER_NAME
fi
if [ "$(docker ps -a -q -f name=$CONTAINER_NAME)" ]; then
        echo "removing container: $CONTAINER_NAME"
        docker rm $CONTAINER_NAME
fi
# Run the Docker container with the specified image and tag
docker run -d -p 80:80 --name $CONTAINER_NAME "$IMAGE_NAME:$TAG"
# Check if the container is running
if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
        echo "Docker container deployed successfully: $CONTAINER_NAME"
else
        echo "Docker container deployment faild"
        exit 1
fi

