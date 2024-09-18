terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.39"
    }
    teleport = {
      version = ">16.0.0"
      source  = "terraform.releases.teleport.dev/gravitational/teleport"
    }
    random = {}
  }
}
