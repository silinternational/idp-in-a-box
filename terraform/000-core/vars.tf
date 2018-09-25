/*
 * Required Application settings
 */
variable "app_name" {
  type = "string"
}

variable "app_env" {
  type = "string"
}

variable "aws_region" {
  default = "us-east-1"
  type    = "string"
}

variable "enable_cloudtrail" {
  type    = "string"
  default = "yes"
}
