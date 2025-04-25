# Bastion Host Public IP
output "bastion_public_ip" {
  description = "Public IP of the Bastion Host"
  value       = aws_instance.bastion.public_ip
}

# WordPress EC2 Private IP
output "wordpress_private_ip" {
  description = "Private IP of the WordPress EC2 instance"
  value       = aws_instance.wordpress.private_ip
}

# RDS Endpoint
output "rds_endpoint" {
  description = "Endpoint of the RDS instance"
  value       = aws_db_instance.capstone_rds.endpoint
}

# phpinfo URL - via SSH port forwarding
output "php_info_url_localhost" {
  description = "phpinfo page via localhost:8080 through SSH tunnel"
  value       = "http://localhost:8080/info.php"
}

# phpinfo URL - via Bastion Public IP
output "php_info_url_bastion" {
  description = "phpinfo page via Bastion public IP"
  value       = "http://${aws_instance.bastion.public_ip}/info.php"
}

# WordPress Setup URL - via localhost (tunnel)
output "wordpress_setup_url_localhost" {
  description = "WordPress setup page via SSH tunnel"
  value       = "http://localhost:8080"
}

# WordPress Setup URL - via Bastion Public IP
output "wordpress_setup_url_bastion" {
  description = "WordPress setup page via Bastion public IP"
  value       = "http://${aws_instance.bastion.public_ip}"
}
