#!/bin/bash

# Update system packages
apt update -y
apt upgrade -y

# Install Docker
apt install -y docker.io
systemctl start docker
systemctl enable docker

# Add ubuntu user to docker group
usermod -a -G docker ubuntu
newgrp docker

# Configure AWS CLI for the ubuntu user
mkdir -p /home/ubuntu/.aws
cat > /home/ubuntu/.aws/config << EOF
[default]
region = us-east-1
output = json
EOF
chown -R ubuntu:ubuntu /home/ubuntu/.aws

# Install Java 17
apt install -y openjdk-17-jdk

# Install Maven
apt install -y maven

# Install Git
apt install -y git

# Install AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
apt install -y unzip
unzip awscliv2.zip
./aws/install

# Install SSM Agent - Ubuntu specific method
sudo snap install amazon-ssm-agent --classic
sudo systemctl enable snap.amazon-ssm-agent.amazon-ssm-agent.service
sudo systemctl start snap.amazon-ssm-agent.amazon-ssm-agent.service
sudo systemctl status snap.amazon-ssm-agent.amazon-ssm-agent.service

# Create application directory
mkdir -p /opt/app
chown ubuntu:ubuntu /opt/app

# Install Jenkins

#!/bin/bash
set -eux

# Create keyrings directory if it doesn't exist
sudo mkdir -p /etc/apt/keyrings

# Download Jenkins GPG key
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

# Add Jenkins APT repository
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | \
  sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update APT and install Jenkins
sudo apt-get update -y
sudo apt-get install -y jenkins

# Configure Jenkins to run on port 8090
sudo sed -i 's/HTTP_PORT=8080/HTTP_PORT=8090/g' /etc/default/jenkins

# Restart Jenkins to apply the new port
sudo systemctl restart jenkins