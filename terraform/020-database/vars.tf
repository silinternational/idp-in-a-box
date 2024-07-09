variable "app_env" {
  type = string
}

variable "app_name" {
  type = string
}

variable "availability_zone" {
  type    = string
  default = ""
}

variable "mysql_user" {
  type = string
}

variable "db_name" {
  type = string
}

variable "security_groups" {
  type = list(string)
}

variable "subnet_group_name" {
  type = string
}

/*
 * Optional variables
 */
variable "engine" {
  type    = string
  default = "mariadb"
}

variable "engine_version" {
  type    = string
  default = ""
}

variable "allocated_storage" {
  type    = string
  default = "8"
}

variable "storage_type" {
  type    = string
  default = "gp2"
}

variable "instance_class" {
  type    = string
  default = "db.t2.micro"
}

variable "backup_retention_period" {
  type    = string
  default = "14"
}

variable "multi_az" {
  type    = string
  default = false
}

variable "skip_final_snapshot" {
  type    = string
  default = true
}

variable "create_passwords" {
  type        = bool
  description = "Set to false to skip creation of database passwords"
  default     = true
}

variable "replicate_source_db" {
  type        = string
  description = "To create a replica DB in a separate region, specify the source database ARN"
  default     = null
}

variable "ca_cert_identifier" {
  type    = string
  default = "rds-ca-rsa2048-g1"
}
