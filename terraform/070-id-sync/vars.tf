variable "memory" {
  type    = string
  default = "200"
}

variable "cpu" {
  type    = string
  default = "200"
}

variable "app_name" {
  type    = string
  default = "id-sync"
}

variable "app_env" {
  type = string
}

variable "cloudwatch_log_group_name" {
  type = string
}

variable "docker_image" {
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

variable "id_broker_access_token" {
  type = string
}

variable "id_broker_adapter" {
  type    = string
  default = "idp"
}

variable "id_broker_assertValidIp" {
  description = "Whether or not to assert IP address for ID Broker API is trusted"
  type        = string
  default     = "true"
}

variable "id_broker_base_url" {
  type = string
}

variable "id_broker_trustedIpRanges" {
  description = "List of valid IP address ranges for ID Broker API"
  type        = list(string)
}

variable "id_store_adapter" {
  type = string
}

variable "id_store_config" {
  type        = map(string)
  description = "A map of configuration data to pass into id-sync as env vars"
}

variable "idp_name" {
  type = string
}

variable "idp_display_name" {
  default = ""
  type    = string
}

variable "ecs_cluster_id" {
  type = string
}

variable "notifier_email_to" {
  default     = ""
  type        = string
  description = "email address for Human Resources (HR) notification messages"
}

variable "alerts_email" {
  default     = ""
  type        = string
  description = "email address for exception messages"
}

variable "sync_safety_cutoff" {
  type    = string
  default = "0.15"
}

variable "allow_empty_email" {
  type    = string
  default = "false"
}

variable "enable_new_user_notification" {
  type    = string
  default = "false"
}

variable "enable_sync" {
  description = "Set the AWS CloudWatch Event Rule is-enabled flag"
  type        = bool
  default     = true
}

variable "event_schedule" {
  description = "AWS Cloudwatch schedule for the sync task"
  type        = string
  default     = "cron(*/15 * * * ? *)"
}

variable "sentry_dsn" {
  description = "Sentry DSN for error logging and alerting"
  type        = string
  default     = ""
}

variable "heartbeat_url" {
  description = "Optional: configure the URL of a monitoring service to call after every successful sync"
  type        = string
  default     = ""
}

variable "heartbeat_method" {
  description = "Optional: configure the http method of a monitoring service to call after every successful sync"
  type        = string
  default     = ""
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
