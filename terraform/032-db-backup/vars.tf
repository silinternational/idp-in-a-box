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

variable "sentry_dsn" {
  description = "Sentry DSN for backup failure notification"
  type        = string
  default     = ""
}

/*
 * Synchronize S3 bucket to Backblaze B2
 */
variable "b2_application_key_id" {
  description = "Backblaze application key ID"
  type        = string
}

variable "b2_application_key" {
  description = "Backblaze application key secret"
  type        = string
}

variable "b2_bucket_name" {
  description = "Name of the Backblaze B2 bucket"
  type        = string
}

variable "b2_path" {
  description = "Path within the Backblaze B2 bucket where files will be stored"
  type        = string
}

variable "backup_b2_cpu" {
  description = "Amount of CPU to allocate to the task"
  type        = string
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket to sync to B2 (e.g. `my-bucket`)"
  type        = string
}

variable "s3_backup_path" {
  description = "Path to be backed up within the AWS S3 bucket"
  type        = string
}

variable "backup_b2_memory" {
  description = "Amount of memory to allocate to the task"
  type        = string
}

variable "log_group_name" {
  description = "The CloudWatch Log Group to write logs to"
  type        = string
}

variable "b2_sync_schedule" {
  description = "S3-to-B2 backup schedule, e.g., 'cron(10 2 * * ? *)'"
  type        = string
}
