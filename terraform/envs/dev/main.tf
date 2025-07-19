terraform {
  required_version = ">= 1.0"

  required_providers {
      aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
       tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
    random = {
      source = "hashicorp/random"
      version="~>3.0"
    }
  }
}
 resource "random_id" "suffix" {
      byte_length =4
 }

provider "aws" {
  region = var.aws_region
}

# Generate SSH key pair for the dev environment
resource "tls_private_key" "dev" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create AWS key pair for the dev environment
resource "aws_key_pair" "dev" {
  key_name  = "${var.project_name}-${var.environment}-keypair-${random_id.suffix.hex}"
  public_key = tls_private_key.dev.public_key_openssh

  tags = {
    Name        = "${var.project_name}-${var.environment}-keypair-${random_id.suffix.hex}"
    Environment = var.environment
    Project     = var.project_name
  }
}

# Save private key to local file for the dev environment
resource "local_file" "private_key" {
  content         = tls_private_key.dev.private_key_pem
  filename        = "${var.project_name}-${var.environment}-keypair.pem"
  file_permission = "0400"
}

module "ec2_instance" {
  source = "../../modules/ec2-instance"

  project_name      = var.project_name
  environment       = var.environment
  instance_type     = var.instance_type
  key_name          = aws_key_pair.dev.key_name # Referencing the *generated* key name
  security_group_id = module.network.security_group_id
  subnet_id         = module.network.public_subnet_id
  user_data         = file("../../scripts/user_data.sh")
}
module "network" {
  source = "../../modules/network"

  project_name         = var.project_name
  environment          = var.environment
  availability_zone    = var.availability_zone
  allowed_cidr_blocks  = var.allowed_cidr_blocks
}

