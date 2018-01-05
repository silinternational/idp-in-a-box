/*
 * Required Application settings
 */
variable "app_name" {
  type = "string"
}

variable "app_env" {
  type = "string"
}

variable "aws_instance" {
  type = "map"
}

variable "aws_region" {
  type = "string"
}

variable "aws_zones" {
  type = "list"
}

variable "cert_domain_name" {
  type = "string"
}

variable "ecs_cluster_name" {
  type = "string"
}

variable "ecs_instance_profile_id" {
  type = "string"
}
