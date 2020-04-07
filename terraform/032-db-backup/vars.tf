variable "app_env" {
  type = "string"
}

variable "app_name" {
  type    = "string"
  default = "db-backup"
}

variable "aws_region" {
  type = "string"
}

variable "cloudwatch_log_group_name" {
  type = "string"
}

variable "cpu" {
  type    = "string"
  default = "32"
}

variable "cron_schedule" {
  type    = "string"
  default = "0 2 * * *"
}

variable "db_names" {
  type = "list"

  default = [
    "emailservice",
    "idbroker",
    "pwmanager",
    "ssp",
  ]
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

variable "idp_name" {
  type = "string"
}

variable "logentries_set_id" {
  type = "string"
}

variable "memory" {
  type    = "string"
  default = "32"
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

variable "service_mode" {
  type    = "string"
  default = "backup"
}

variable "vpc_id" {
  type = "string"
}
