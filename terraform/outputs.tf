output "dev_public_ip" {
  description = "Public IP of dev environment"
  value       = module.dev_environment.public_ip
}

output "test_public_ip" {
  description = "Public IP of test environment"
  value       = module.test_environment.public_ip
}

output "prod_public_ip" {
  description = "Public IP of prod environment"
  value       = module.prod_environment.public_ip
}
output "ssh_private_key_path" {
  description = "Path to the generated SSH private key"
  value       = local_file.private_key.filename
}

output "ssh_connection_command" {
  description = "SSH command to connect to instances"
  value       = "ssh -i ${local_file.private_key.filename} ubuntu@<instance-public-ip>"
}
output "private_key_pem" {
value = tls_private_key.dev.private_key_pem
sensitive = true
}