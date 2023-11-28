/*
 * Required Application settings
 */
variable "cluster_name" {
  type = string
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

