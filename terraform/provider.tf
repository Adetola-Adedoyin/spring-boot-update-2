provider "aws" {
  region = var.aws_region
}

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tls = { # Required for generating SSH keys
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    local = { # Required for saving private key to local file
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
    random = { # Required for generating random IDs
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Generate SSH key pair
resource "tls_private_key" "main" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create AWS key pair from the generated public key
resource "aws_key_pair" "main" {
  key_name  = "${var.project_name}-keypair"
  public_key = tls_private_key.main.public_key_openssh

  tags = {
    Name    = "${var.project_name}-keypair"
    Project = var.project_name
  }
}

# Save private key to local file for SSH access
resource "local_file" "private_key" {
  content         = tls_private_key.main.private_key_pem
  filename        = "${var.project_name}-keypair.pem"
  file_permission = "0400"
}