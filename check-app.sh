#!/bin/bash

# Get the EC2 instance ID
INSTANCE_ID=$(aws ec2 describe-instances \
  --filters "Name=tag:Project,Values=springboot-devops" "Name=instance-state-name,Values=running" \
  --query "Reservations[0].Instances[0].InstanceId" \
  --output text)

echo "Found instance ID: $INSTANCE_ID"

# Get the public IP
PUBLIC_IP=$(aws ec2 describe-instances \
  --instance-ids "$INSTANCE_ID" \
  --query "Reservations[0].Instances[0].PublicIpAddress" \
  --output text)

echo "Public IP: $PUBLIC_IP"

# Check if the instance is reachable
echo "Checking if instance is reachable..."
aws ec2 describe-instance-status \
  --instance-ids "$INSTANCE_ID" \
  --query "InstanceStatuses[0].{InstanceStatus:InstanceStatus.Status, SystemStatus:SystemStatus.Status}"

# Check if Docker is running
echo "Checking Docker status..."
aws ssm send-command \
  --instance-ids "$INSTANCE_ID" \
  --document-name "AWS-RunShellScript" \
  --parameters "commands=[\"systemctl status docker\"]" \
  --output text

# Check running containers
echo "Checking running containers..."
aws ssm send-command \
  --instance-ids "$INSTANCE_ID" \
  --document-name "AWS-RunShellScript" \
  --parameters "commands=[\"docker ps\"]" \
  --output text

# Check application logs
echo "Checking application logs..."
aws ssm send-command \
  --instance-ids "$INSTANCE_ID" \
  --document-name "AWS-RunShellScript" \
  --parameters "commands=[\"docker logs springboot-app\"]" \
  --output text

# Check if port 8080 is listening
echo "Checking if port 8080 is listening..."
aws ssm send-command \
  --instance-ids "$INSTANCE_ID" \
  --document-name "AWS-RunShellScript" \
  --parameters "commands=[\"netstat -tulpn | grep 8080\"]" \
  --output text

# Try to curl the application locally
echo "Testing application locally on the instance..."
aws ssm send-command \
  --instance-ids "$INSTANCE_ID" \
  --document-name "AWS-RunShellScript" \
  --parameters "commands=[\"curl -v localhost:8080\"]" \
  --output text