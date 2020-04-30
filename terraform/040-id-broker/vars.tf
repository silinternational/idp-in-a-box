variable "app_env" {
  type        = "string"
  description = "Environment name, ex: 'stg' or 'prod'"
}

variable "app_name" {
  type        = "string"
  default     = "id-broker"
  description = "Used in ECS service names and logs, best to leave as default."
}

variable "aws_region" {
  type = "string"
}

variable "cloudflare_domain" {
  type = "string"
}

variable "cloudwatch_log_group_name" {
  type = "string"
}

variable "contingent_user_duration" {
  type    = "string"
  default = "+4 weeks"
}

variable "cpu" {
  type        = "string"
  description = "Amount of CPU to allocate to container, recommend '250' for production"
  default     = "250"
}

variable "cpu_cron" {
  type        = "string"
  description = "Amount of CPU to allocate to cron container, recommend '128' for production"
  default     = "128"
}

variable "db_name" {
  type = "string"
}

variable "desired_count" {
  type    = "string"
  default = "1"
}

variable "docker_image" {
  type = "string"
}

variable "ecs_cluster_id" {
  type = "string"
}

variable "ecsServiceRole_arn" {
  type = "string"
}

variable "email_repeat_delay_days" {
  type    = "string"
  default = "31"
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

variable "email_signature" {
  type    = "string"
  default = ""
}

variable "event_schedule" {
  type    = "string"
  default = "cron(0 0 * * ? *)"
}

variable "ga_client_id" {
  description = "Used by Google Analytics to distinguish the user."
  type        = "string"
  default     = ""
}

variable "ga_tracking_id" {
  description = "The Google Analytics property id (e.g. UA-12345678-12)"
  type        = "string"
  default     = ""
}

variable "help_center_url" {
  type = "string"
}

variable "hibp_check_interval" {
  type    = "string"
  default = "+1 week"
}

variable "hibp_check_on_login" {
  type    = "string"
  default = "true"
}

variable "hibp_grace_period" {
  type    = "string"
  default = "+1 week"
}

variable "hibp_tracking_only" {
  type    = "string"
  default = "false"
}

variable "hibp_notification_bcc" {
  type    = "string"
  default = ""
}

variable "idp_display_name" {
  type    = "string"
  default = ""
}

variable "idp_name" {
  description = "Short name of IdP for logs, something like 'acme'"
}

variable "inactive_user_period" {
  type    = "string"
  default = "+18 months"
}

variable "inactive_user_deletion_enable" {
  type    = "string"
  default = "false"
}

variable "internal_alb_dns_name" {
  description = "The DNS name for the IdP-in-a-Box's internal Application Load Balancer."
  type        = "string"
}

variable "internal_alb_listener_arn" {
  description = "The ARN for the IdP-in-a-Box's internal ALB's listener."
  type        = "string"
}

variable "invite_email_delay_seconds" {
  type    = "string"
  default = "0"
}

variable "invite_grace_period" {
  type    = "string"
  default = "+3 months"
}

variable "invite_lifespan" {
  type    = "string"
  default = "+1 month"
}

variable "lost_security_key_email_days" {
  type    = "string"
  default = "62"
}

variable "memory" {
  type        = "string"
  description = "Amount of memory to allocate to container, recommend '200' for production"
  default     = "200"
}

variable "memory_cron" {
  type        = "string"
  description = "Amount of memory to allocate to cron container, recommend '200' for more than 500 active users"
  default     = "200"
}

variable "method_add_interval" {
  type    = "string"
  default = "+6 months"
}

variable "method_codeLength" {
  type    = "string"
  default = "6"
}

variable "method_gracePeriod" {
  type    = "string"
  default = "+15 days"
}

variable "method_lifetime" {
  type    = "string"
  default = "+5 days"
}

variable "method_maxAttempts" {
  type    = "string"
  default = "10"
}

variable "mfa_add_interval" {
  type    = "string"
  default = "+30 days"
}

variable "mfa_allow_disable" {
  type    = "string"
  default = "true"
}

variable "mfa_lifetime" {
  type    = "string"
  default = "+2 hours"
}

variable "mfa_manager_bcc" {
  type    = "string"
  default = ""
}

variable "mfa_manager_help_bcc" {
  type    = "string"
  default = ""
}

variable "mfa_required_for_new_users" {
  type    = "string"
  default = "false"
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

variable "minimum_backup_codes_before_nag" {
  type    = "string"
  default = "4"
}

variable "mysql_host" {
  type = "string"
}

variable "mysql_pass" {
  type = "string"
}

variable "mysql_user" {
  type = "string"
}

variable "notification_email" {
  description = "Email address to send notifications to"
  type        = "string"
}

variable "password_expiration_grace_period" {
  type    = "string"
  default = "+30 days"
}

variable "password_lifespan" {
  type    = "string"
  default = "+1 year"
}

variable "password_mfa_lifespan_extension" {
  type    = "string"
  default = "+4 years"
}

variable "password_profile_url" {
  type = "string"
}

variable "password_reuse_limit" {
  type    = "string"
  default = "10"
}

variable "profile_review_interval" {
  type    = "string"
  default = "+12 months"
}

variable "run_task" {
  type    = "string"
  default = "cron/all"
}

variable "send_get_backup_codes_emails" {
  type    = "string"
  default = "true"
}

variable "send_invite_emails" {
  type    = "string"
  default = "true"
}

variable "send_lost_security_key_emails" {
  type    = "string"
  default = "true"
}

variable "send_method_purged_emails" {
  type    = "string"
  default = "true"
}

variable "send_method_reminder_emails" {
  type    = "string"
  default = "true"
}

variable "send_mfa_disabled_emails" {
  type    = "string"
  default = "true"
}

variable "send_mfa_enabled_emails" {
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

variable "send_mfa_rate_limit_emails" {
  type    = "string"
  default = "true"
}

variable "send_password_changed_emails" {
  type    = "string"
  default = "true"
}

variable "send_password_expired_emails" {
  type    = "string"
  default = "true"
}

variable "send_password_expiring_emails" {
  type    = "string"
  default = "true"
}

variable "send_refresh_backup_codes_emails" {
  type    = "string"
  default = "true"
}

variable "send_welcome_emails" {
  type    = "string"
  default = "true"
}

variable "ssl_policy" {
  type = "string"
}

variable "subdomain" {
  type = "string"
}

variable "subject_for_get_backup_codes" {
  type    = "string"
  default = ""
}

variable "subject_for_invite" {
  type    = "string"
  default = ""
}

variable "subject_for_lost_security_key" {
  type    = "string"
  default = ""
}

variable "subject_for_method_purged" {
  type    = "string"
  default = ""
}

variable "subject_for_method_reminder" {
  type    = "string"
  default = ""
}

variable "subject_for_method_verify" {
  type    = "string"
  default = ""
}

variable "subject_for_mfa_disabled" {
  type    = "string"
  default = ""
}

variable "subject_for_mfa_enabled" {
  type    = "string"
  default = ""
}

variable "subject_for_mfa_manager" {
  type    = "string"
  default = ""
}

variable "subject_for_mfa_manager_help" {
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

variable "subject_for_mfa_rate_limit" {
  type    = "string"
  default = ""
}

variable "subject_for_password_changed" {
  type    = "string"
  default = ""
}

variable "subject_for_password_expired" {
  type    = "string"
  default = ""
}

variable "subject_for_password_expiring" {
  type    = "string"
  default = ""
}

variable "subject_for_refresh_backup_codes" {
  type    = "string"
  default = ""
}

variable "subject_for_welcome" {
  type    = "string"
  default = ""
}

variable "support_email" {
  type = "string"
}

variable "support_name" {
  type    = "string"
  default = "support"
}

variable "vpc_id" {
  type = "string"
}

variable "wildcard_cert_arn" {
  type = "string"
}
