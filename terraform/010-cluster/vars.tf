/*
 * Required Application settings
 */
variable "app_name" {
  type = string
}

variable "app_env" {
  type = string
}

variable "aws_instance" {
  type = map(string)
}

variable "aws_region" {
  type = string
}

variable "aws_region_secondary" {
  description = "secondary AWS region - leave blank if a secondary region is not desired"
  default     = ""
  type        = string
}

variable "aws_zones" {
  type = list(string)
}

variable "aws_zones_secondary" {
  type = list(string)
  default = []
}

variable "cert_domain_name" {
  type = string
}

variable "ecs_cluster_name" {
  type = string
}

variable "ecs_instance_profile_id" {
  type = string
}

variable "idp_name" {
  type = string
}

variable "asg_additional_user_data" {
  type    = string
  default = ""
}

variable "tags" {
  description = "Tags to add to the autoscaling group and EC2 instances"
  type        = map(string)
  default     = {}
}
