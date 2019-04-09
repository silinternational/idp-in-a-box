variable "alb_dns_name" {
  type = "string"
}

variable "alb_https_listener_arn" {
  type = "string"
}

variable "alerts_email" {
  type = "string"
}

variable "api_subdomain" {
  type = "string"
}

variable "app_env" {
  type = "string"
}

variable "app_name" {
  type        = "string"
  default     = "pw-manager"
  description = "Used in ECS service names and logs, best to leave as default."
}

variable "auth_saml_checkResponseSigning" {
  default = "true"
}

variable "auth_saml_entityId" {
  description = "SP entity ID"
  type        = "string"
}

variable "auth_saml_idpCertificate" {
  description = "Public cert data for IdP"
  type        = "string"
}

variable "auth_saml_requireEncryptedAssertion" {
  default = "true"
}

variable "auth_saml_signRequest" {
  description = "Whether or not to sign auth requests"
  type        = "string"
  default     = "true"
}

variable "auth_saml_sloUrl" {
  description = "SLO url for IdP"
  type        = "string"
}

variable "auth_saml_spCertificate" {
  description = "Public cert data for this SP"
  type        = "string"
}

variable "auth_saml_spPrivateKey" {
  description = "Private cert data for this SP"
  type        = "string"
}

variable "auth_saml_ssoUrl" {
  description = "SSO url for IdP"
  type        = "string"
}

variable "cd_user_username" {
  type = "string"
}

variable "cloudflare_domain" {
  type = "string"
}

variable "code_length" {
  description = "Number of digits in reset code."
  type        = "string"
  default     = "6"
}

variable "cpu" {
  type        = "string"
  description = "Amount of CPU to allocate to container, recommend '250' for production"
  default     = "64"
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

variable "from_name" {
  description = "Name to send emails from"
  type        = "string"
}

variable "id_broker_access_token" {
  type = "string"
}

variable "id_broker_assertValidBrokerIp" {
  description = "Whether or not to assert IP address for ID Broker API is trusted"
  default     = "true"
}

variable "id_broker_base_uri" {
  type = "string"
}

variable "id_broker_validIpRanges" {
  description = "List of valid IP ranges to ID Broker API"
  type        = "list"
}

variable "idp_display_name" {
  description = "Display name of IdP for UI, something like 'ACME Inc.'"
  type        = "string"
}

variable "idp_name" {
  description = "Short name of IdP for logs, something like 'acme'"
  type        = "string"
}

variable "logentries_set_id" {
  type = "string"
}

variable "memory" {
  description = "Amount of memory to allocate to container, recommend '128' for production"
  default     = "100"
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

variable "password_rule_enablehibp" {
  description = "enable haveibeenpwned.com password check"
  type        = "string"
  default     = "true"
}

variable "password_rule_maxlength" {
  description = "maximum password length"
  type        = "string"
  default     = "255"
}

variable "password_rule_minlength" {
  description = "minimum password length"
  type        = "string"
  default     = "10"
}

variable "password_rule_minscore" {
  description = "minimum password score"
  type        = "string"
  default     = "3"
}

variable "recaptcha_key" {
  type = "string"
}

variable "recaptcha_secret" {
  type = "string"
}

variable "support_email" {
  description = "Email address for end user support, displayed on PW UI"
  type        = "string"
}

variable "support_feedback" {
  description = "Email address for end user feedback, displayed on PW UI"
  type        = "string"
}

variable "support_phone" {
  description = "Phone number for end user support, displayed on PW UI"
  type        = "string"
}

variable "support_url" {
  description = "URL for end user support, displayed on PW UI"
  type        = "string"
}

variable "ui_subdomain" {
  type = "string"
}

variable "vpc_id" {
  type = "string"
}

variable "wildcard_cert_arn" {
  type = "string"
}
