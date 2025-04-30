variable "secret_salt" {
  description = "This allows for porting the value over from a primary to a secondary workspace (a random string that is 64 characters long)."
  type        = string
  default     = ""
}

variable "memory" {
  type    = string
  default = "96"
}

variable "cpu" {
  type    = string
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

variable "subdomain" {
  type = string
}

variable "cloudflare_domain" {
  type = string
}

variable "cloudwatch_log_group_name" {
  type = string
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

variable "show_saml_errors" {
  type    = string
  default = "false"
}

variable "theme_color_scheme" {
  type    = string
  default = "indigo-purple"
}

variable "trusted_ip_addresses" {
  type = list(string)
}

variable "desired_count" {
  type    = string
  default = "1"
}

variable "analytics_id" {
  type = string
}

variable "help_center_url" {
  type = string
}

variable "admin_email" {
  type = string
}

variable "admin_name" {
  type = string
}

variable "create_dns_record" {
  description = "Controls creation of a DNS CNAME record for the ECS service."
  type        = bool
  default     = true
}

variable "appconfig_app_id" {
  description = "DEPRECATED"
  type        = string
  default     = ""
}

variable "appconfig_env_id" {
  description = "DEPRECATED"
  type        = string
  default     = ""
}

variable "cduser_username" {
  type    = string
  default = "IAM user name for the CD user. Used to create ECS deployment policy."
}
