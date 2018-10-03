variable "memory" {
  default = "100"
}

variable "cpu" {
  default = "64"
}

variable "logentries_set_id" {
  type = "string"
}

variable "app_name" {
  type    = "string"
  default = "pw-manager"
}

variable "app_env" {
  type = "string"
}

variable "vpc_id" {
  type = "string"
}

variable "alb_https_listener_arn" {
  type = "string"
}

variable "api_subdomain" {
  type = "string"
}

variable "cloudflare_domain" {
  type = "string"
}

variable "id_broker_assertValidBrokerIp" {
  description = "Whether or not to assert IP address for ID Broker API is trusted"
  default     = "true"
}

variable "id_broker_validIpRanges" {
  description = "List of valid IP ranges to ID Broker API"
  type        = "list"
}

variable "idp_name" {
  type = "string"
}

variable "idp_display_name" {
  type = "string"
}

variable "idp_username_hint" {
  type    = "string"
  default = "Username or email address"
}

variable "alerts_email" {
  type = "string"
}

variable "support_email" {
  type = "string"
}

variable "from_email" {
  type = "string"
}

variable "from_name" {
  type = "string"
}

variable "logo_url" {
  type = "string"
}

variable "db_name" {
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

variable "recaptcha_key" {
  type = "string"
}

variable "recaptcha_secret" {
  type = "string"
}

variable "docker_image" {
  type = "string"
}

variable "ui_subdomain" {
  type = "string"
}

variable "id_broker_access_token" {
  type = "string"
}

variable "id_broker_base_uri" {
  type = "string"
}

variable "ecs_cluster_id" {
  type = "string"
}

variable "ecsServiceRole_arn" {
  type = "string"
}

variable "alb_dns_name" {
  type = "string"
}

variable "wildcard_cert_arn" {
  type = "string"
}

variable "cd_user_username" {
  type = "string"
}

variable "desired_count" {
  type    = "string"
  default = "1"
}

variable "email_service_useEmailService" {
  description = "Whether or not to use Email Service API to send emails"
  default     = "true"
}

variable "email_service_baseUrl" {
  description = "Base URL to Email Service API"
}

variable "email_service_accessToken" {
  description = "Access Token for Email Service API"
}

variable "email_service_assertValidIp" {
  description = "Whether or not to assert IP address for Email Service API is trusted"
  default     = "true"
}

variable "email_service_validIpRanges" {
  description = "List of valid IP ranges to Email Service API"
  type        = "list"
}

variable "auth_saml_signRequest" {
  description = "Whether or not to sign auth requests"
  type        = "string"
  default     = "true"
}

variable "auth_saml_checkResponseSigning" {
  default = "true"
}

variable "auth_saml_requireEncryptedAssertion" {
  default = "true"
}

variable "auth_saml_idpCertificate" {
  description = "Public cert data for IdP"
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

variable "auth_saml_entityId" {
  description = "SP entity ID"
  type        = "string"
}

variable "auth_saml_ssoUrl" {
  description = "SSO url for IdP"
  type        = "string"
}

variable "auth_saml_sloUrl" {
  description = "SLO url for IdP"
  type        = "string"
}
