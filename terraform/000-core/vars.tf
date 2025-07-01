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
  type        = bool
  default     = false
}

variable "create_cd_user" {
  description = "Set to false if an IAM user for continuous deployment is not needed"
  type        = bool
  default     = true
}


/*
 * Optional variables
 */

variable "app_env" {
  description = "The abbreviated version of the environment used for naming resources, typically either stg or prod. Default: 'prod'"
  type        = string
  default     = "prod"
}

variable "appconfig_app_name" {
  description = "DEPRECATED"
  type        = string
  default     = ""
}
