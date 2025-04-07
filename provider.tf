provider "aws" {
  region     = "us-west-2"
#  access_key = var.aws_access
#  secret_key = var.aws_secret
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}