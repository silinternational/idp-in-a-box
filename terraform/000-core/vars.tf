/*
 * Required Application settings
 */
variable "app_name" {
  type = string
}

variable "app_env" {
  type = string
}

variable "aws_region" {
  default = "us-east-1"
  type    = string
}

variable "create_acm_cert" {
  default = false
}

variable "cert_domain" {
  description = "TLD for certificate domain"
}

variable "cloudflare_token" {
  description = "The Cloudflare limited access API token"
}
