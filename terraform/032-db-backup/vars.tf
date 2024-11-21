variable "app_env" {
  type = string
}

variable "app_name" {
  type    = string
  default = "db-backup"
}

variable "backup_user_name" {
  type    = string
  default = null
}

variable "cloudwatch_log_group_name" {
  type = string
}

variable "cpu" {
  type    = string
  default = "32"
}

variable "cron_schedule" {
  description = "Schedule for CRON execution. DEPRECATED: use event_schedule"
  type        = string
  default     = ""
}

variable "db_names" {
  type = list(string)

  default = [
    "emailservice",
    "idbroker",
    "pwmanager",
    "ssp",
  ]
}

variable "docker_image" {
  type = string
}

variable "ecs_cluster_id" {
  type = string
}

variable "event_schedule" {
  description = "Schedule for backup task execution. Default: `cron(0 2 * * ? *)"
  type        = string
  default     = "cron(0 2 * * ? *)"
}

variable "idp_name" {
  type = string
}

variable "memory" {
  type    = string
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

variable "service_mode" {
  type    = string
  default = "backup"
}

variable "enable_aws_backup" {
  description = "enable backup using AWS Backup service"
  type        = bool
  default     = false
}

variable "aws_backup_schedule" {
  description = "schedule for AWS Backup, in AWS Event Bridge format"
  type        = string
  default     = "cron(0 14 * * ? *)" # Every day at 14:00 UTC, 12-hour offset from backup script
}

variable "aws_backup_notification_events" {
  description = "The names of the backup events that should trigger an email notification"
  type        = list(string)
  default     = ["BACKUP_JOB_FAILED"]
}

variable "backup_sns_email" {
  description = "Optional: email address to receive backup event notifications"
  type        = string
  default     = ""
}

variable "delete_recovery_point_after_days" {
  description = "Number of days after which AWS Backup recovery points are deleted"
  type        = number
  default     = 100
}
