variable "memory" {
  default = "200"
}

variable "memory_cron" {
  default = "50"
}

variable "cpu" {
  default = "250"
}

variable "cpu_cron" {
  default = "128"
}

variable "app_name" {
  type    = "string"
  default = "id-broker"
}

variable "app_env" {
  type = "string"
}

variable "vpc_id" {
  type = "string"
}

variable "ssl_policy" {
  type = "string"
}

variable "wildcard_cert_arn" {
  type = "string"
}

variable "logentries_set_id" {
  type = "string"
}

variable "idp_display_name" {
  type    = "string"
  default = ""
}

variable "idp_name" {
  type = "string"
}

variable "docker_image" {
  type = "string"
}

variable "db_name" {
  type = "string"
}

variable "email_service_accessToken" {
  description = "Access Token for Email Service API"
}

variable "email_service_assertValidIp" {
  description = "Whether or not to assert IP address for Email Service API is trusted"
  default     = "true"
}

variable "email_service_baseUrl" {
  description = "Base URL to Email Service API"
}

variable "email_service_validIpRanges" {
  description = "List of valid IP ranges to Email Service API"
  type        = "list"
}

variable "ga_tracking_id" {
  description = "The Google Analytics property id (e.g. UA-12345678-12)"
  type        = "string"
  default     = ""
}

variable "ga_client_id" {
  description = "Used by Google Analytics to distinguish the user."
  type        = "string"
  default     = ""
}

variable "internal_alb_dns_name" {
  description = "The DNS name for the IdP-in-a-Box's internal Application Load Balancer."
  type        = "string"
}

variable "internal_alb_listener_arn" {
  description = "The ARN for the IdP-in-a-Box's internal ALB's listener."
  type        = "string"
}

variable "ldap_admin_password" {
  type = "string"
}

variable "ldap_admin_username" {
  type = "string"
}

variable "ldap_base_dn" {
  type = "string"
}

variable "ldap_domain_controllers" {
  type = "string"
}

variable "ldap_use_ssl" {
  type = "string"
}

variable "ldap_use_tls" {
  type = "string"
}

variable "mfa_totp_apibaseurl" {
  type = "string"
}

variable "mfa_totp_apikey" {
  type = "string"
}

variable "mfa_totp_apisecret" {
  type = "string"
}

variable "mfa_u2f_apibaseurl" {
  type = "string"
}

variable "mfa_u2f_apikey" {
  type = "string"
}

variable "mfa_u2f_apisecret" {
  type = "string"
}

variable "mfa_u2f_appid" {
  type = "string"
}

variable "notification_email" {
  type = "string"
}

variable "migrate_pw_from_ldap" {
  type = "string"
}

variable "mysql_host" {
  type = "string"
}

variable "mysql_user" {
  type = "string"
}

variable "mysql_pass" {
  type = "string"
}

variable "ecs_cluster_id" {
  type = "string"
}

variable "ecsServiceRole_arn" {
  type = "string"
}

variable "subdomain" {
  type = "string"
}

variable "cloudflare_domain" {
  type = "string"
}

variable "desired_count" {
  type    = "string"
  default = "1"
}

variable "email_signature" {
  type    = "string"
  default = ""
}

variable "password_forgot_url" {
  type = "string"
}

variable "password_profile_url" {
  type = "string"
}

variable "support_email" {
  type = "string"
}

variable "support_name" {
  type    = "string"
  default = "support"
}

variable "help_center_url" {
  type = "string"
}

variable "send_invite_emails" {
  type    = "string"
  default = "true"
}

variable "send_mfa_rate_limit_emails" {
  type    = "string"
  default = "true"
}

variable "send_password_changed_emails" {
  type    = "string"
  default = "true"
}

variable "send_welcome_emails" {
  type    = "string"
  default = "true"
}

variable "send_get_backup_codes_emails" {
  type    = "string"
  default = "true"
}

variable "send_refresh_backup_codes_emails" {
  type    = "string"
  default = "true"
}

variable "send_lost_security_key_emails" {
  type    = "string"
  default = "true"
}

variable "send_mfa_option_added_emails" {
  type    = "string"
  default = "true"
}

variable "send_mfa_option_removed_emails" {
  type    = "string"
  default = "true"
}

variable "send_mfa_enabled_emails" {
  type    = "string"
  default = "true"
}

variable "send_mfa_disabled_emails" {
  type    = "string"
  default = "true"
}

variable "subject_for_invite" {
  type    = "string"
  default = ""
}

variable "subject_for_mfa_rate_limit" {
  type    = "string"
  default = ""
}

variable "subject_for_password_changed" {
  type    = "string"
  default = ""
}

variable "subject_for_welcome" {
  type    = "string"
  default = ""
}

variable "subject_for_get_backup_codes" {
  type    = "string"
  default = ""
}

variable "subject_for_refresh_backup_codes" {
  type    = "string"
  default = ""
}

variable "subject_for_lost_security_key" {
  type    = "string"
  default = ""
}

variable "subject_for_mfa_option_added" {
  type    = "string"
  default = ""
}

variable "subject_for_mfa_option_removed" {
  type    = "string"
  default = ""
}

variable "subject_for_mfa_enabled" {
  type    = "string"
  default = ""
}

variable "subject_for_mfa_disabled" {
  type    = "string"
  default = ""
}

variable "subject_for_mfa_manager" {
  type    = "string"
  default = ""
}

variable "subject_for_method_verify" {
  type    = "string"
  default = ""
}

variable "lost_security_key_email_days" {
  type    = "string"
  default = "62"
}

variable "minimum_backup_codes_before_nag" {
  type    = "string"
  default = "4"
}

variable "email_repeat_delay_days" {
  type    = "string"
  default = "31"
}

variable "password_reuse_limit" {
  type    = "string"
  default = "10"
}

variable "password_lifespan" {
  type    = "string"
  default = "+1 year"
}

variable "password_expiration_grace_period" {
  type    = "string"
  default = "+30 days"
}

variable "invite_lifespan" {
  type    = "string"
  default = "+1 month"
}

variable "invite_grace_period" {
  type    = "string"
  default = "+3 months"
}

variable "mfa_lifetime" {
  type    = "string"
  default = "+2 hours"
}

variable "method_lifetime" {
  type    = "string"
  default = "+1 day"
}

variable "method_gracePeriod" {
  type    = "string"
  default = "+15 days"
}

variable "method_codeLength" {
  type    = "string"
  default = "6"
}

variable "method_maxAttempts" {
  type    = "string"
  default = "10"
}

variable "mfa_add_interval" {
  type    = "string"
  default = "+30 days"
}

variable "mfa_review_interval" {
  type    = "string"
  default = "+6 months"
}

variable "method_add_interval" {
  type    = "string"
  default = "+6 months"
}

variable "method_review_interval" {
  type    = "string"
  default = "+12 months"
}
