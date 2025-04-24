output "ec2_public_ip" {
  description = "The public IP of the EC2 instance"
  value       = aws_instance.capstone.public_ip
}

output "wordpress_setup_url" {
  description = "URL for WordPress setup"
  value       = "http://${aws_instance.capstone.public_ip}/"
}

output "php_info_url" {
  description = "URL to check PHP info page"
  value       = "http://${aws_instance.capstone.public_ip}/info.php"
}

output "rds_endpoint" {
  description = "The RDS endpoint to be used as DB_HOST in WordPress"
  value       = aws_db_instance.capstone_rds.endpoint
}
