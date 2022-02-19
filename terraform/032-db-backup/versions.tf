
terraform {
  required_version = ">= 0.12"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.61"
    }
    template = {
      source = "hashicorp/template"
    }
  }
}
