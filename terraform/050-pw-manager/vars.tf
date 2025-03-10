variable "alb_dns_name" {
  type = string
}

variable "alb_https_listener_arn" {
  type = string
}

variable "alerts_email" {
  description = "Email to which to send error alerts"
  type        = string
  default     = ""
}

variable "alerts_email_enabled" {
  description = "Set to true to disable email alerts. Must be a string for insertion into task definition."
  type        = string
  default     = "true"
}

variable "api_subdomain" {
  type = string
}

variable "app_env" {
  type = string
}

variable "app_name" {
  type        = string
  default     = "pw-manager"
  description = "Used in ECS service names and logs, best to leave as default."
}

variable "auth_saml_checkResponseSigning" {
  type    = string
  default = "true"
}

variable "auth_saml_entityId" {
  description = "SP entity ID. DEPRECATED: future versions will use \"$${var.api_subdomain}.$${var.cloudflare_domain}\""
  type        = string
}

variable "auth_saml_idp_url" {
  description = "Base URL of the IdP, e.g. \"https://login.example.com\""
  type        = string
  default     = ""
}

variable "auth_saml_idpCertificate" {
  description = "Public cert data for IdP"
  type        = string
}

variable "auth_saml_requireEncryptedAssertion" {
  type    = string
  default = "true"
}

variable "auth_saml_signRequest" {
  description = "Whether or not to sign auth requests"
  type        = string
  default     = "true"
}

variable "auth_saml_sloUrl" {
  description = "Single logout URL for IdP. DEPRECATED: specify auth_saml_idp_url"
  type        = string
  default     = ""
}

variable "auth_saml_spCertificate" {
  description = "Public cert data for this SP"
  type        = string
}

variable "auth_saml_spPrivateKey" {
  description = "Private cert data for this SP"
  type        = string
}

variable "auth_saml_ssoUrl" {
  description = "Single sign-on URL for IdP. DEPRECATED: specify auth_saml_idp_url"
  type        = string
  default     = ""
}

variable "cduser_username" {
  type    = string
  default = "IAM user name for the CD user. Used to create ECS deployment policy."
}

variable "cloudflare_domain" {
  type = string
}

variable "cloudwatch_log_group_name" {
  type = string
}

variable "code_length" {
  description = "Number of digits in reset code."
  type        = string
  default     = "6"
}

variable "cpu" {
  type        = string
  description = "Amount of CPU to allocate to container, recommend '250' for production"
  default     = "64"
}

variable "db_name" {
  type = string
}

variable "desired_count" {
  type    = string
  default = "1"
}

variable "docker_image" {
  type = string
}

variable "ecs_cluster_id" {
  type = string
}

variable "ecsServiceRole_arn" {
  type = string
}

variable "email_service_accessToken" {
  description = "Access Token for Email Service API"
  type        = string
}

variable "email_service_assertValidIp" {
  description = "Whether or not to assert IP address for Email Service API is trusted"
  type        = string
  default     = "true"
}

variable "email_service_baseUrl" {
  description = "Base URL to Email Service API"
  type        = string
}

variable "email_service_validIpRanges" {
  description = "List of valid IP ranges to Email Service API"
  type        = list(string)
}

variable "email_signature" {
  description = "Email signature line"
  type        = string
}

variable "extra_hosts" {
  description = "Extra hosts for the API task definition, e.g. [\"host.example.com:192.168.1.1\"]"
  type        = string
  default     = "null"
}

variable "help_center_url" {
  type = string
}

variable "id_broker_access_token" {
  type = string
}

variable "id_broker_assertValidBrokerIp" {
  description = "Whether or not to assert IP address for ID Broker API is trusted"
  type        = string
  default     = "true"
}

variable "id_broker_base_uri" {
  type = string
}

variable "id_broker_validIpRanges" {
  description = "List of valid IP ranges to ID Broker API"
  type        = list(string)
}

variable "idp_display_name" {
  description = "Display name of IdP for UI, something like 'ACME Inc.'"
  type        = string
}

variable "idp_name" {
  description = "Short name of IdP for logs, something like 'acme'"
  type        = string
}

variable "memory" {
  description = "Amount of memory to allocate to container, recommend '128' for production"
  type        = string
  default     = "100"
}

variable "mysql_host" {
  type = string
}

variable "mysql_pass" {
  type = string
}

variable "mysql_user" {
  type = string
}

variable "password_rule_alpha_and_numeric" {
  description = "require alpha and numeric characters in password, use \"false\" or \"true\" strings"
  type        = string
  default     = "false"
}

variable "password_rule_enablehibp" {
  description = "enable haveibeenpwned.com password check"
  type        = string
  default     = "true"
}

variable "password_rule_maxlength" {
  description = "maximum password length"
  type        = string
  default     = "255"
}

variable "password_rule_minlength" {
  description = "minimum password length"
  type        = string
  default     = "10"
}

variable "password_rule_minscore" {
  description = "minimum password score"
  type        = string
  default     = "3"
}

variable "recaptcha_key" {
  type = string
}

variable "recaptcha_secret" {
  type = string
}

variable "sentry_dsn" {
  description = "Sentry DSN for error logging and alerting"
  type        = string
  default     = ""
}

variable "support_email" {
  description = "Email address for end user support, displayed on PW UI and in emails"
  type        = string
}

variable "support_feedback" {
  description = "Email address for end user feedback, displayed on PW UI"
  type        = string
}

variable "support_name" {
  description = "Name for end user support, displayed on PW UI and in emails"
  type        = string
}

variable "support_phone" {
  description = "Phone number for end user support, displayed on PW UI"
  type        = string
}

variable "support_url" {
  description = "URL for end user support, displayed on PW UI"
  type        = string
}

variable "ui_subdomain" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "create_dns_record" {
  description = "Controls creation of a DNS CNAME record for the ECS service."
  type        = bool
  default     = true
}

variable "appconfig_app_id" {
  description = "AppConfig application ID"
  type        = string
  default     = ""
}

variable "appconfig_env_id" {
  description = "AppConfig environment ID"
  type        = string
  default     = ""
}
