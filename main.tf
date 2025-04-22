terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.94.1"
    }
  }
}

# Lookup existing private subnet by its name tag
#data "aws_subnet" "capstone_private" {
#  filter {
#    name   = "tag:Name"
#    values = ["capstone-private-subnet"]
#  }
#}
