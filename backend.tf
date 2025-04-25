terraform {
  backend "s3" {
    bucket  = "capstone-terraform-emre-9001"
    key     = "global/s3/terraform.tfstate"
    region  = "us-west-2"
    encrypt = true
  }
}
