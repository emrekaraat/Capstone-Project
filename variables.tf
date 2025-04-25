# EC2 Configuration Variables
variable "ami_id" {
  description = "AMI to use for EC2 instance"
  default     = "ami-087f352c165340ea1"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t3.micro"
}

variable "key_name" {
  description = "Key pair name for EC2"
  default     = "vockey"
}

# WordPress DB & MariaDB Passwords
variable "db_root_password" {
  description = "MariaDB root password"
  type        = string
  sensitive   = true
}

variable "db_user" {
  description = "WordPress DB username"
  type        = string
}

variable "db_user_password" {
  description = "Password for the WordPress database user"
  type        = string
  sensitive   = true
}

# Name of the WordPress database
# This variable's value is defined in the Terraform Cloud workspace
variable "db_name" {
  description = "Name of the WordPress database"
  type        = string
}

# RDS endpoint to be used in WordPress configuration
# This variable's value is defined in the Terraform Cloud workspace
variable "db_host" {
  description = "RDS endpoint to be used in WordPress config"
  type        = string
}
