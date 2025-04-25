terraform {
  backend "s3" {
    bucket         = "capstone-terraform-emre-3501"   # sama as S3 bucket 
    key            = "global/s3/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
  }
}
