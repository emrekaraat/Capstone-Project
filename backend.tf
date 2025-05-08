terraform {
  backend "remote" {
    organization = "AWS-Cloud-Emre"

    workspaces {
      name = "AWS-Capstone-Project"
    }
  }
}
