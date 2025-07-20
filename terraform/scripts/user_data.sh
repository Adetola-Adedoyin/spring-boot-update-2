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

# Install and ensure SSM Agent is running
mkdir -p /tmp/ssm
cd /tmp/ssm
wget https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_amd64/amazon-ssm-agent.deb
dpkg -i amazon-ssm-agent.deb

# Make sure SSM agent starts on boot and is running now
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent

# Add a startup script to ensure SSM is always running
cat > /etc/systemd/system/ssm-autostart.service << EOF
[Unit]
Description=Ensure SSM Agent is running
After=network.target

[Service]
Type=oneshot
ExecStart=/bin/bash -c "systemctl is-active --quiet amazon-ssm-agent || systemctl restart amazon-ssm-agent"

[Install]
WantedBy=multi-user.target
EOF

# Enable the autostart service
systemctl daemon-reload
systemctl enable ssm-autostart.service

# Create application directory
mkdir -p /opt/app
chown ubuntu:ubuntu /opt/app

# Pull the Docker image from Docker Hub
docker pull teeboss/springboot-demo:new
