#!/bin/bash

# Get the EC2 instance ID
INSTANCE_ID=$(aws ec2 describe-instances \
  --filters "Name=tag:Project,Values=springboot-devops" "Name=instance-state-name,Values=running" \
  --query "Reservations[0].Instances[0].InstanceId" \
  --output text)

echo "Found instance ID: $INSTANCE_ID"

# Send test commands
aws ssm send-command \
  --instance-ids "$INSTANCE_ID" \
  --document-name "AWS-RunShellScript" \
  --parameters 'commands=[
    "# Stop and remove any existing containers",
    "docker stop test-nginx || true",
    "docker rm test-nginx || true",
    
    "# Run a simple nginx container",
    "docker run -d --name test-nginx -p 8090:80 nginx",
    "sleep 5",
    
    "# Check container status",
    "docker ps",
    
    "# Check if port is listening",
    "netstat -tulpn | grep 8090",
    
    "# Test local connectivity",
    "curl -v http://localhost:8090",
    
    "# Check if firewall is blocking",
    "sudo iptables -L -n",
    
    "# Check system logs for any network issues",
    "dmesg | grep -i drop"
  ]' \
  --output text