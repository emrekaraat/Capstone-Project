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