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

variable "aws_region_secondary" {
  description = "secondary AWS region - leave blank if a secondary region is not desired"
  default     = ""
  type        = string
}

variable "create_acm_cert" {
  default = false
}

variable "cert_domain" {
  description = "TLD for certificate domain"
}
