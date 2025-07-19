# Generate random suffix for unique resource names
resource "random_id" "suffix" {
  byte_length = 4
}

# Use default VPC
data "aws_vpc" "default" {
  default = true
}

# Use default subnets
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_subnet" "selected" {
  id = data.aws_subnets.default.ids[0]
}

# Security Group
resource "aws_security_group" "main" {
  name        = "${var.project_name}-${var.environment}-sg-${random_id.suffix.hex}"
  description = "Security group for ${var.project_name} ${var.environment}"
  vpc_id      = data.aws_vpc.default.id

  # SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  # HTTP access
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  # HTTPS access
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  # Spring Boot default port
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }
  
  # Jenkins port
  ingress {
    from_port   = 8090
    to_port     = 8090
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }
  # Prometheus (port 9090)
ingress {
  from_port   = 9090
  to_port     = 9090
  protocol    = "tcp"
  cidr_blocks = var.allowed_cidr_blocks
}

# Grafana (port 3000)
ingress {
  from_port   = 3000
  to_port     = 3000
  protocol    = "tcp"
  cidr_blocks = var.allowed_cidr_blocks
}

  # All outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-sg-${random_id.suffix.hex}"
    Environment = var.environment
    Project     = var.project_name
  }
}
