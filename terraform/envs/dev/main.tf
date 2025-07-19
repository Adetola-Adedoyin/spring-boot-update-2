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

# SSH key pair generation removed - using SSM for access instead

module "ec2_instance" {
  source = "../../modules/ec2-instance"

  project_name      = var.project_name
  environment       = var.environment
  instance_type     = var.instance_type
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

