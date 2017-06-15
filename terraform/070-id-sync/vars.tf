variable "logentries_set_id" {
  type = "string"
}
variable "app_name" {
  type = "string"
  default = "id-sync"
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
variable "subdomain" {
  type = "string"
}
variable "cloudflare_domain" {
  type = "string"
}
variable "docker_image" {
  type = "string"
}
variable "id_broker_access_token" {
  type = "string"
}
variable "id_broker_adapter" {
  type = "string"
  default = "idp"
}
variable "id_broker_base_url" {
  type = "string"
}
variable "id_store_adapter" {
  type = "string"
}
variable "id_store_config" {
  type = "map"
  description = "A map of configuration data to pass into id-sync as env vars"
}
variable "idp_name" {
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
