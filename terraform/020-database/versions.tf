
terraform {
  required_version = ">= 0.12"
  required_providers {
    random = {
      source = "hashicorp/random"
    }
    template = {
      source = "hashicorp/template"
    }
  }
}
