
terraform {
  required_version = ">= 0.14"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 6.0.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 2.0.0, < 4.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 2.2.0, < 4.0.0"
    }
  }
}
