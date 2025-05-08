terraform {
  backend "remote" {
    organization = "AWS-Cloud-Emre"

    workspaces {
      name = "capstone-cli"
    }
  }
}
