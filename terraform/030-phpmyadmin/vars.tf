/*
 * Application settings
 */
variable "app_name" {
  type = "string"
  default = "phpmyadmin"
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
variable "rds_address" {
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
