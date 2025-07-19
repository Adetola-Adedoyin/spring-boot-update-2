variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

# key_name variable removed as we're using SSM for access

variable "security_group_id" {
  description = "Security group ID for the instance"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for the instance"
  type        = string
}

variable "user_data" {
  description = "User data script for instance initialization"
  type        = string
  default     = ""
}
