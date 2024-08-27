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

variable "use_transit_gateway" {
  description = "Set to true to attach a transit gateway to this VPC and route traffic to it. Use in conjunction with transit_gateway_id and create_nat_gateway=false."
  type        = bool
  default     = false
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

variable "private_subnet_cidr_blocks" {
  description = "The CIDR blocks for the VPC's private subnets (one per AZ, in order). There must be at least as many private CIDRs as AZs, and they must not overlap the public CIDRs."
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.22.0/24", "10.0.33.0/24", "10.0.44.0/24"]
}

variable "public_subnet_cidr_blocks" {
  description = "The CIDR blocks for the VPC's public subnets (one per AZ, in order). There must be at least as many public CIDRs as AZs, and they must not overlap the private CIDRs."
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.20.0/24", "10.0.30.0/24", "10.0.40.0/24"]
}

variable "tags" {
  description = "Tags to add to the autoscaling group and EC2 instances"
  type        = map(string)
  default     = {}
}

variable "transit_gateway_id" {
  description = "The ID of the transit gateway to attach to when use_transit_gateway = true."
  type        = string
  default     = ""
}

variable "transit_gateway_default_route_table_association" {
  description = "Whether or not to associate with the default route table of the transit gateway."
  type        = bool
  default     = true
}

variable "transit_gateway_default_route_table_propagation" {
  description = "Whether or not to send propagation of this route to the default route table of the transit gateway."
  type        = bool
  default     = true
}

variable "vpc_cidr_block" {
  description = "The block of IP addresses (as a CIDR) the VPC should use"
  type        = string
  default     = "10.0.0.0/16"
}

variable "log_retention_in_days" {
  description = "Number of days to retain CloudWatch application logs"
  default     = 30
  type        = number
}
