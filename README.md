## Explained all about the project/screenshots in google docs:
    https://docs.google.com/document/d/e/2PACX-1vQ5zwMK63GUE6nBmOB1Fo3Q7C9MFsFWw05VcgsnJmC7Y1dF3ca0417gaxq-5Hj9PYbMcE2_rrfJiE3h/pub
    
## Capstone Project repo: 
    https://github.com/Jagannathan88/capstone-project.git
    
## Dockerfile: 
    • It pulls nginx latest docker image
    • Copy capstone-project app content to the web service directory in the nginx image 
    • Builds a custom nginx image of capstone web app
    • exposing port 80

## build.sh:
    • Read and stores the user data in a variable IMAGE_NAME
    • Read and stores the user data in a variable TAG
    • Executes the build command docker build -t "$IMAGE_NAME:$TAG" .
    • Used if_else condition to display the success and failure message of build process
    
 # Deploy.sh
### Prompting for Input
    Prompts the user to enter the Docker image name, tag, and container name, and stores the inputs in variables IMAGE_NAME, TAG, and CONTAINER_NAME, respectively.
### Check and Stop Existing Container
    • Checks if there is a running container with the specified name.
    • docker ps -q -f name=$CONTAINER_NAME lists the IDs of running containers with the given name.
    • If a running container is found, it stops the container.
### Remove Existing Container
    • Checks if there is a stopped or existing container with the specified name.
    • docker ps -a -q -f name=$CONTAINER_NAME lists the IDs of all containers (running or stopped) with the given name.
    • If a container is found, it removes the container.
### Run the New Docker Container
    • Runs a new Docker container with the specified image and tag.
    • docker run -d -p 80:80 --name $CONTAINER_NAME "$IMAGE_NAME:$TAG" starts the container in detached mode (-d), maps port 80 on the host to port 80 in the container (-p 80:80), and names the container.
### Verify Container Deployment
    • Verifies if the container is running by checking the container's ID.
    • docker ps -q -f name=$CONTAINER_NAME lists the IDs of running containers with the given name.
    • If the container is running, it prints a success message.
    • If the container is not running, it prints a failure message and exits the script with a non-zero status code.
### Summary
    This script allows the user to deploy a Docker container with specific details (image name, tag, container name). It handles stopping and removing any existing container with the same name to avoid conflicts, runs the new container, and verifies the deployment. The checks ensure that the environment is clean before starting a new container, and the script provides feedback on whether the deployment was successful or not.

 # Testing video clips:
    • dev_ environment_auto_build_trigger.webm --> Video explanation for dev environment auto build trigger 
    • prod_ environment_auto_build_trigger.webm --> Video explanation for prod environment auto build trigger
    • tested_dev_prod_at_a_time.webm --> Made a video clip for dev and prod environment both testing at a time
    
 # Jenkins script
#### Environment Variables
    • DOCKER_HUB_CREDENTIALS: The ID of the Jenkins credentials for Docker Hub.
    • REPO_URL: URL of the GitHub repository.
    • BRANCH: Branch to checkout from the repository.
    • DOCKER_IMAGE: Name and tag of the Docker image to be built.
    • CONTAINER_NAME: Name of the Docker container to be deployed.
### Stages
#### Checkout Stage
    • cleanWs(): Cleans the workspace before checking out the code.
    • git branch: "${env.BRANCH}", url: "${env.REPO_URL}": Checks out the specified branch from the GitHub repository.
#### Build and Push Docker Image Stage
    • docker.withRegistry('https://index.docker.io/v1/', "${env.DOCKER_HUB_CREDENTIALS}"): Authenticates with Docker Hub using the specified credentials.
    • def dockerImage = docker.build("${env.DOCKER_IMAGE}"): Builds the Docker image.
    • dockerImage.push(): Pushes the built Docker image to Docker Hub.
#### Deploy Container Stage
    • Stops and removes any existing container with the specified name.
    • Runs the new Docker container with the specified image, mapping port 80 on the host to port 80 in the container.
#### Post Actions
    • post { always { ... } }: Executes the cleanup steps regardless of the pipeline's success or failure.
    • sh 'docker container prune -f || true': Removes all stopped containers.
    • sh 'docker image prune -f || true': Removes all unused images.
    • sh 'docker volume prune -f || true': Removes all unused volumes.
    • sh 'docker network prune -f || true': Removes all unused networks.

   # Terraform main.tf
#### Provider Configuration
      This specifies the AWS provider and the region where resources will be created. In this case, the region is ap-south-1.
#### EC2 Instance Resource
    • aws_instance "jenkins_server": Defines an EC2 instance resource.
    • ami: The Amazon Machine Image ID for Ubuntu Server.
    • instance_type: The instance type (t2.micro).
    • key_name: The name of the SSH key pair for accessing the instance.
    • tags: Tags the instance with the name "JenkinsServer".
    • user_data: Specifies a shell script to run on instance startup. This script:
        ◦ Updates the package list and installs necessary dependencies (Java, Jenkins, Docker).
        ◦ Adds Jenkins and Docker repositories and keys.
        ◦ Installs Jenkins and Docker.
        ◦ Starts and enables the Jenkins service.
        ◦ Adds the Jenkins user to the Docker group and restarts Jenkins.
#### To associates the EC2 instance with the security group
    security_groups = [aws_security_group.jenkins_sg.name]
    This line is part of the aws_instance resource block, and it associates the EC2 instance with the security group defined in the script.
        • The aws_instance resource block is used to define an EC2 instance.
        • The aws_security_group resource block defines a security group that allows all TCP and SSH traffic.
#### Security Group Resource
    • aws_security_group "jenkins_sg": Defines a security group for the EC2 instance.
    • name: The name of the security group.
    • description: A description of the security group.
    • ingress: Allows all incoming TCP traffic from any IP address (0.0.0.0/0).
    • egress: Allows all outgoing traffic to any IP address (0.0.0.0/0).
#### Output
    • output "public_ip": Outputs the public IP address of the EC2 instance.
#### Post Actions
    • post { always { ... } }: Executes the cleanup steps regardless of the pipeline's success or failure.
    • sh 'docker container prune -f || true': Removes all stopped containers.
    • sh 'docker image prune -f || true': Removes all unused images.
    • sh 'docker volume prune -f || true': Removes all unused volumes.
    • sh 'docker network prune -f || true': Removes all unused networks.
#### Summary
    This Terraform script:
    1. Sets up an AWS provider in the ap-south-1 region.
    2. Creates an EC2 instance with Ubuntu Server, installs Jenkins and Docker, and configures them.
    3. Defines a security group that allows all TCP and SSH traffic.
    4. Outputs the public IP address of the EC2 instance.
