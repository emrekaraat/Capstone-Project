# Bastion Host Public IP
output "bastion_public_ip" {
  description = "Public IP of the Bastion Host"
  value       = aws_instance.bastion.public_ip
}

# RDS Database Endpoint
output "rds_endpoint" {
  description = "RDS Database Endpoint"
  value       = aws_db_instance.capstone_rds.endpoint
}

# ALB DNS Name
output "alb_dns" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.capstone_alb.dns_name
}

# Note: Auto Scaling instances do not have a stable private IP.
# If you're still using aws_instance.capstone (i.e., static EC2), uncomment the following:

# output "wordpress_private_ip" {
#   description = "Private IP of the WordPress EC2"
#   value       = aws_instance.capstone.private_ip
# }
