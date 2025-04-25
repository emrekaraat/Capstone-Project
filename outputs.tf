# Bastion Host Public IP
output "bastion_public_ip" {
  description = "Public IP of the Bastion Host"
  value       = aws_instance.bastion.public_ip
}

# WordPress EC2 Private IP
output "wordpress_private_ip" {
  description = "Private IP of the WordPress EC2"
  value       = aws_instance.capstone.private_ip
}

# RDS Endpoint
output "rds_endpoint" {
  description = "RDS Endpoint"
  value       = aws_db_instance.capstone_rds.endpoint
}
