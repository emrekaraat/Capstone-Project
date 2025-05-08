terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.94.1"
    }
  }
}

# Read the Galatasaray HTML content from file
locals {
  galatasaray_content = file("${path.module}/assets/galatasaray_content.html")
}
