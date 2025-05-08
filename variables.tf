# ----------------------------------------
# EC2 Configuration Variables
# ----------------------------------------

variable "ami_id" {
  description = "AMI ID to use for launching EC2 instances"
  default     = "ami-087f352c165340ea1"  # Amazon Linux 2 (example)
}

variable "instance_type" {
  description = "EC2 instance type for WordPress and Auto Scaling"
  default     = "t3.micro"
}

variable "key_name" {
  description = "Name of the SSH key pair for EC2 access"
  default     = "vockey"
}

# ----------------------------------------
# Database Configuration Variables
# ----------------------------------------

variable "db_root_password" {
  description = "Root password for MariaDB (used for initial setup)"
  type        = string
  sensitive   = true                      # Hidden in CLI and logs
}

variable "db_user" {
  description = "Username for the WordPress database"
  type        = string
}

variable "db_user_password" {
  description = "Password for the WordPress database user"
  type        = string
  sensitive   = true                      # Hidden in CLI and logs
}

variable "db_name" {
  description = "Name of the WordPress database"
  type        = string
}

# ----------------------------------------
# Notification & Monitoring
# ----------------------------------------

variable "notification_email" {
  description = "Email address to receive system or alarm notifications"
  type        = string
  sensitive   = true
}