output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.main.id
}

output "public_ip" {
  description = "Public IP address of the instance"
  value       = aws_instance.main.public_ip
}

output "private_ip" {
  description = "Private IP address of the instance"
  value       = aws_instance.main.private_ip
}

output "public_dns" {
  description = "Public DNS name of the instance"
  value       = aws_instance.main.public_dns
}
output "private_key_pem" {
  value = tls_private_key.dev.private_key_pem
  sensitive = true
}