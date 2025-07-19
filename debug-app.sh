#!/bin/bash

# Get the EC2 instance ID
INSTANCE_ID=$(aws ec2 describe-instances \
  --filters "Name=tag:Project,Values=springboot-devops" "Name=instance-state-name,Values=running" \
  --query "Reservations[0].Instances[0].InstanceId" \
  --output text)

echo "Found instance ID: $INSTANCE_ID"

# Check Docker containers
echo "Checking Docker containers..."
aws ssm send-command \
  --instance-ids "$INSTANCE_ID" \
  --document-name "AWS-RunShellScript" \
  --parameters 'commands=["docker ps -a"]' \
  --output text

# Check if port 8090 is listening
echo "Checking if port 8090 is listening..."
aws ssm send-command \
  --instance-ids "$INSTANCE_ID" \
  --document-name "AWS-RunShellScript" \
  --parameters 'commands=["netstat -tulpn | grep 8090"]' \
  --output text

# Check Docker logs
echo "Checking Docker logs..."
aws ssm send-command \
  --instance-ids "$INSTANCE_ID" \
  --document-name "AWS-RunShellScript" \
  --parameters 'commands=["docker logs springboot-app"]' \
  --output text

# Try HTTP not HTTPS
echo "Testing HTTP connection locally..."
aws ssm send-command \
  --instance-ids "$INSTANCE_ID" \
  --document-name "AWS-RunShellScript" \
  --parameters 'commands=["curl -v http://localhost:8090"]' \
  --output text