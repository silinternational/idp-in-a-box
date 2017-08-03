variable "app_env" {
  type = "string"
}

variable "app_name" {
  type    = "string"
  default = "id-broker"
}

variable "cloudflare_domain" {
  type = "string"
}

variable "cpu" {
  default = "250"
}

variable "desired_count" {
  type    = "string"
  default = "1"
}

variable "db_name" {
  type = "string"
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

variable "ldap_admin_password" {
  type = "string"
}

variable "ldap_admin_username" {
  type = "string"
}

variable "ldap_base_dn" {
  type = "string"
}

variable "ldap_domain_controllers" {
  type = "string"
}

variable "ldap_use_ssl" {
  type = "string"
}

variable "ldap_use_tls" {
  type = "string"
}

variable "logentries_set_id" {
  type = "string"
}

variable "mailer_host" {
  type = "string"
}

variable "mailer_password" {
  type = "string"
}

variable "mailer_usefiles" {
  type    = "string"
  default = "false"
}

variable "mailer_username" {
  type = "string"
}

variable "memory" {
  default = "96"
}

variable "migrate_pw_from_ldap" {
  type = "string"
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

variable "notification_email" {
  type = "string"
}

variable "ssl_policy" {
  type = "string"
}

variable "subdomain" {
  type = "string"
}

variable "vpc_id" {
  type = "string"
}

variable "wildcard_cert_arn" {
  type = "string"
}
