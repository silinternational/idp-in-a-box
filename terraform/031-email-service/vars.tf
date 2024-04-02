variable "app_env" {
  type = string
}

variable "app_name" {
  type    = string
  default = "email-service"
}

variable "aws_region" {
  description = "WARNING: This is not used. The region is more reliably determined from the aws_region data source."
  type        = string
  default     = ""
}

variable "cloudflare_domain" {
  type = string
}

variable "cloudwatch_log_group_name" {
  type = string
}

variable "cpu_api" {
  default = "32"
}

variable "cpu_cron" {
  default = "100"
}

variable "db_name" {
  type = string
}

variable "desired_count_api" {
  description = "The number of API containers. Note that the cron container also runs apache."
  type        = string
  default     = "2"
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

variable "email_brand_color" {
  description = "The CSS color to use for branding in emails (e.g. `rgb(0, 93, 154)`)."
  type        = string
}

variable "email_brand_logo" {
  description = "The fully qualified URL to an image for use as logo in emails."
  type        = string
}

variable "email_queue_batch_size" {
  default     = "10"
  description = "How many queued emails to process per run."
  type        = string
}

variable "from_email" {
  description = "Email address to send emails from. See `from_name`"
  type        = string
}

variable "from_name" {
  description = "Name to use when sending emails"
  default     = ""
  type        = string
}

variable "idp_name" {
  type = string
}

variable "internal_alb_dns_name" {
  description = "The DNS name for the IdP-in-a-Box's internal Application Load Balancer."
  type        = string
}

variable "internal_alb_listener_arn" {
  description = "The ARN for the IdP-in-a-Box's internal ALB's listener."
  type        = string
}

variable "mailer_host" {
  description = "SMTP hostname - if omitted, SES will be used"
  type        = string
  default     = ""
}

variable "mailer_password" {
  description = "password, used with mailer_username for authentication to SMTP server"
  type        = string
  default     = ""
}

variable "mailer_usefiles" {
  description = "Controls whether YiiMailer should write to files instead of sending emails"
  type        = string
  default     = "false"
}

variable "mailer_username" {
  description = "username, used with mailer_password for authentication to SMTP server"
  type        = string
  default     = ""
}

variable "memory_api" {
  default = "96"
}

variable "memory_cron" {
  default = "32"
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

variable "notification_email" {
  type = string
}

variable "ssl_policy" {
  type = string
}

variable "subdomain" {
  description = "The subdomain for email-service, without an embedded region in it (e.g. 'email', NOT 'email-us-east-1')"
  type        = string
}

variable "vpc_id" {
  type = string
}

variable "wildcard_cert_arn" {
  type = string
}

variable "enable_cron" {
  default = true
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
