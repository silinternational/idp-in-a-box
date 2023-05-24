variable "secret_salt" {
  type    = string
  default = ""
  description = "This allows for porting the value over from a primary to a secondary workspace (a random string that is 64 characters long)."
}

variable "memory" {
  default = "96"
}

variable "cpu" {
  default = "150"
}

variable "app_name" {
  type    = string
  default = "simplesamlphp"
}

variable "app_env" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "alb_https_listener_arn" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "subdomain" {
  type = string
}

variable "cloudflare_domain" {
  type = string
}

variable "cloudwatch_log_group_name" {
  type = string
}

variable "delete_remember_me_on_logout" {
  type    = string
  default = "false"
}

variable "docker_image" {
  type = string
}

variable "enable_debug" {
  type    = string
  default = "false"
}

variable "password_change_url" {
  type = string
}

variable "password_forgot_url" {
  type = string
}

variable "hub_mode" {
  type    = string
  default = "false"
}

variable "id_broker_access_token" {
  type = string
}

variable "id_broker_assert_valid_ip" {
  type    = string
  default = "true"
}

variable "id_broker_base_uri" {
  type = string
}

variable "id_broker_trusted_ip_ranges" {
  type    = list(string)
  default = []
}

variable "logging_level" {
  type    = string
  default = "NOTICE"
}

variable "mfa_learn_more_url" {
  type = string
}

variable "mfa_setup_url" {
  type = string
}

variable "db_name" {
  type = string
}

variable "mysql_host" {
  type = string
}

variable "mysql_user" {
  type = string
}

variable "mysql_pass" {
  type = string
}

variable "profile_url" {
  type = string
}

variable "recaptcha_key" {
  type = string
}

variable "recaptcha_secret" {
  type = string
}

variable "remember_me_secret" {
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

variable "idp_name" {
  type = string
}

variable "idp_display_name" {
  type = string
}

variable "show_saml_errors" {
  type    = string
  default = "false"
}

variable "theme_color_scheme" {
  type    = string
  default = "indigo-purple"
}

variable "theme_use" {
  type    = string
  default = "material:material"
}

variable "trusted_ip_addresses" {
  type = list(string)
}

variable "desired_count" {
  default = "1"
}

variable "analytics_id" {
  type = string
}

variable "help_center_url" {
  type = string
}

variable "admin_email" {
}

variable "admin_name" {
}

variable "trust_cloudflare_ips" {
  default = ""
}
