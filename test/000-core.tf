module "defaults" {
  source = "../terraform/000-core"

  app_name    = "test"
  app_env     = "testing"
  cert_domain = "example.com"
}

module "create_acm_cert" {
  source = "../terraform/000-core"

  app_name        = "test"
  app_env         = "testing"
  cert_domain     = "example.com"
  create_acm_cert = true
}

module "no_create_user" {
  source = "../terraform/000-core"

  app_name       = "test"
  app_env        = "testing"
  cert_domain    = "example.com"
  create_cd_user = false
}

provider "aws" {
  region = "us-east-1"
}

provider "cloudflare" {}

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
  }
}
