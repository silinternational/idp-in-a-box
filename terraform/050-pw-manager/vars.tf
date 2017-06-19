variable "logentries_set_id" {
  type = "string"
}
variable "app_name" {
  type = "string"
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
variable "idp_name" {
  type = "string"
}
variable "idp_username_hint" {
  type = "string"
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
variable "mailer_usefiles" {
  type = "string"
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
