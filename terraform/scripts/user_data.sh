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

# Install SSM Agent (should be pre-installed on Ubuntu 22.04, but ensure it's running)
apt install -y amazon-ssm-agent
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent

# Create application directory
mkdir -p /opt/app
chown ubuntu:ubuntu /opt/app

# Stop and disable any existing Jenkins service
systemctl stop jenkins || true
systemctl disable jenkins || true

# Remove Jenkins if installed
apt-get remove -y jenkins || true
apt-get purge -y jenkins || true

# Kill any process using port 8080
fuser -k 8080/tcp || true

# Ensure port 8080 is free
netstat -tulpn | grep 8080 || echo "Port 8080 is free"