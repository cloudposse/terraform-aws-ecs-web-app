terraform {
  required_version = ">= 1.1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.34"
    }
    github = {
      source  = "integrations/github"
      version = ">= 4.2.0"
    }
  }
}
