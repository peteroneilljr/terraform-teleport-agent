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

provider "aws" {
  profile = var.aws_teleport_profile

  region = var.aws_region
  default_tags {
    tags = var.aws_tags
  }
}

provider "random" {}

provider "teleport" {
  addr               = "${var.teleport_proxy_address}:443"
  identity_file_path = var.teleport_identity_path
}
