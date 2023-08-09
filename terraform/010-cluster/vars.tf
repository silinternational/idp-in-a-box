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

variable "aws_zones" {
  type = list(string)
}

variable "cert_domain_name" {
  type = string
}

variable "create_dashboard" {
  description = "Set to false to remove the Cloudwatch Dashboard"
  type        = bool
  default     = true
}

variable "create_nat_gateway" {
  description = "Set to false to remove NAT gateway and associated route"
  type        = bool
  default     = true
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
