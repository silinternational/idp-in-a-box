terraform {
  required_version = ">= 1.0"
  required_providers {
    # tflint-ignore: terraform_required_providers
    aws = {
      source = "hashicorp/aws"
    }
    # tflint-ignore: terraform_required_providers
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "cloudflare" {}
