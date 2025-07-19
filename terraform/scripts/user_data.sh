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