variable "memory" {
  default = "96"
}

variable "cpu" {
  default = "250"
}

variable "app_name" {
  type    = "string"
  default = "id-broker"
}

variable "app_env" {
  type = "string"
}

variable "vpc_id" {
  type = "string"
}

variable "ssl_policy" {
  type = "string"
}

variable "wildcard_cert_arn" {
  type = "string"
}

variable "logentries_set_id" {
  type = "string"
}

variable "idp_name" {
  type = "string"
}

variable "docker_image" {
  type = "string"
}

variable "db_name" {
  type = "string"
}

variable "internal_alb_dns_name" {
  description = "The DNS name for the IdP-in-a-Box's internal Application Load Balancer."
  type = "string"
}

variable "internal_alb_listener_arn" {
  description = "The ARN for the IdP-in-a-Box's internal ALB's listener."
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

variable "mailer_usefiles" {
  type    = "string"
  default = "false"
}

variable "mailer_host" {
  type = "string"
}

variable "mailer_username" {
  type = "string"
}

variable "mailer_password" {
  type = "string"
}

variable "notification_email" {
  type = "string"
}

variable "migrate_pw_from_ldap" {
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

variable "ecs_cluster_id" {
  type = "string"
}

variable "ecsServiceRole_arn" {
  type = "string"
}

variable "subdomain" {
  type = "string"
}

variable "cloudflare_domain" {
  type = "string"
}

variable "desired_count" {
  type    = "string"
  default = "1"
}
