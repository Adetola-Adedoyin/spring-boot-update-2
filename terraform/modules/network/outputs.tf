output "vpc_id" {
  description = "ID of the VPC"
  value       = data.aws_vpc.default.id
}

output "vpc_cidr" {
  description = "CIDR block of the default VPC"
  value       = data.aws_vpc.default.cidr_block
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = data.aws_subnet.selected.id
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.main.id
}