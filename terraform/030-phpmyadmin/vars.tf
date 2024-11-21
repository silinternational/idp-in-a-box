/*
 * Application settings
 */
variable "app_name" {
  type    = string
  default = "phpmyadmin"
}

variable "app_env" {
  type = string
}

variable "idp_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "alb_https_listener_arn" {
  type = string
}

variable "subdomain" {
  type = string
}

variable "cloudflare_domain" {
  type = string
}

variable "enable" {
  type    = bool
  default = "true"
}

variable "rds_address" {
  type = string
}

variable "ecs_cluster_id" {
  type = string
}

variable "ecsServiceRole_arn" {
  type = string
}

variable "alb_dns_name" {
  type = string
}

variable "cpu" {
  type    = string
  default = "32"
}

variable "memory" {
  type    = string
  default = "128"
}

variable "upload_limit" {
  description = "set the maximum POST size for apache and php-fpm, this will change upload_max_filesize and post_max_size values, format as [0-9+](K,M,G)"
  type        = string
  default     = "20M"
}
