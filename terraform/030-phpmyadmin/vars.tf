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

variable "enable_ssl" {
  description = <<-EOT
    When set to "1", enforces SSL usage for the MySQL connection.
    https://github.com/phpmyadmin/docker?tab=readme-ov-file#connect-to-the-database-over-ssl
  EOT
  type        = string
  default     = "0"
}

variable "ssl_ca_base64" {
  description = <<-EOT
    Set to the base64 encoded contents of the SSL CA certificate bundle.
    https://github.com/phpmyadmin/docker?tab=readme-ov-file#variables-that-can-store-the-file-contents-using-_base64
  EOT
  type        = string
  default     = ""
}

variable "upload_limit" {
  description = "set the maximum POST size for apache and php-fpm, this will change upload_max_filesize and post_max_size values, format as [0-9+](K,M,G)"
  type        = string
  default     = "20M"
}
