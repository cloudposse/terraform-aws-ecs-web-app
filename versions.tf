terraform {
  required_version = ">= 0.13.0"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      # TODO: Remove upper bound after the transitive dependency `cloudposse/codebuild/aws` gets
      #       proper support for AWS provider v5.
      #       Related pull request: https://github.com/cloudposse/terraform-aws-codebuild/pull/123
      version = ">= 3.34, < 5.0"
    }
  }
}
