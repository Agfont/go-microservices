terraform {
  required_version = ">= 1.7.0"

  cloud {
    organization = "agfont-org"

    workspaces {
      name = "go-microservices"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.38"
    }
  }
}