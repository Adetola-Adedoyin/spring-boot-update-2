output "vpc_id" {
  description = "ID of the VPC"
  value       = module.network.vpc_id
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = module.network.public_subnet_id
}

output "security_group_id" {
  description = "ID of the security group"
  value       = module.network.security_group_id
}

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = module.ec2_instance.instance_id
}

output "public_ip" {
  description = "Public IP address of the instance"
  value       = module.ec2_instance.public_ip
}

output "private_ip" {
  description = "Private IP address of the instance"
  value       = module.ec2_instance.private_ip
}

output "public_dns" {
  description = "Public DNS name of the instance"
  value       = module.ec2_instance.public_dns
}
output "private_key_pem" {
  value     = module.ec2_instance.private_key_pem
  sensitive = true
}
