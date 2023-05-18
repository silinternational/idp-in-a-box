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

variable "cert_domain" {
  description = "TLD for certificate domain"
  type        = string
}

variable "create_acm_cert" {
  description = "Set to true if an ACM certificate is needed"
  default     = false
}

variable "create_cd_user" {
  description = "Set to false if an IAM user for continuous deployment is not needed"
  default     = true
}

