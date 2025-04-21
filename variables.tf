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
