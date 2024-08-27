variable "app_env" {
  type = string
}

variable "app_name" {
  type    = string
  default = "db-backup"
}

variable "aws_region" {
  description = "This is not used. The region is more reliably determined from the aws_region data source."
  type        = string
  default     = ""
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

variable "ecsServiceRole_arn" {
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

variable "vpc_id" {
  type = string
}

variable "enable_aws_backup" {
  description = "enable backup using AWS Backup service"
  type        = bool
  default     = false
}

variable "aws_backup_cron_schedule" {
  description = "cron-type schedule for AWS Backup"
  type        = string
  default     = "0 14 * * ? *" # Every day at 14:00 UTC, 12-hour offset from backup script
}

variable "aws_backup_notification_events" {
  description = "The names of the backup events that should trigger an email notification"
  type        = list(string)
  default     = ["BACKUP_JOB_FAILED"]
}
