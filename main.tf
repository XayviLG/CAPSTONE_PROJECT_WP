provider "aws" {
  region = var.AWS_REGION
}
terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 5.8.0"
        }
    }
}