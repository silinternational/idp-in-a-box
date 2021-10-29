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
  default     = ""
  description = "TLD for certificate domain, required when create_acm_cert is true"
}
