provider "aws" {
  region = "ap-south-1"  # Change to your preferred region
}

resource "aws_instance" "jenkins_server" {
  ami                    = "ami-0ad21ae1d0696ad58"  # Ubuntu Server 20.04 LTS (HVM), SSD Volume Type
  instance_type          = "t2.micro"
  key_name               = "capstone"  # Replace with your key pair name

  tags = {
    Name = "JenkinsServer"
  }

  user_data = <<-EOF
              #!/bin/bash
              exec > /var/log/user-data.log 2>&1
              set -e

              # Update package list and install dependencies
              sudo apt-get update
              sudo apt-get install -y fontconfig openjdk-17-jre apt-transport-https ca-certificates curl software-properties-common

              # Verify Java installation
              java -version || { echo 'Java installation failed'; exit 1; }

              # Add Jenkins repository and key
              sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
              echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

              # Update package list again and install Jenkins
              sudo apt-get update
              sudo apt-get install -y jenkins || { echo 'Jenkins installation failed'; exit 1; }

              # Start and enable Jenkins service
              sudo systemctl start jenkins || { echo 'Failed to start Jenkins'; exit 1; }
              sudo systemctl enable jenkins

              # Add Docker repository and key
              curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
              sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

              # Update package list again and install Docker
              sudo apt-get update
              sudo apt-get install -y docker-ce

              # Add Jenkins user to Docker group and restart Jenkins
              sudo usermod -aG docker jenkins
              sudo systemctl restart jenkins
              EOF

  security_groups = [aws_security_group.jenkins_sg.name]
}

resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins_sg"
  description = "Allow all TCP and SSH traffic"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "public_ip" {
  value = aws_instance.jenkins_server.public_ip
}

