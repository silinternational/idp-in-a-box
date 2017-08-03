variable "app_env" {
  type = "string"
}

variable "app_name" {
  type    = "string"
  default = "email-service"
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

variable "email_brand_color" {
  description = "The CSS color to use for branding in emails (e.g. `rgb(0, 93, 154).`"
  type = "string"
}

variable "email_brand_logo" {
  description = "The fully qualified URL to an image."
  type = "string"
}

variable "email_queue_batch_size" {
  default = "10"
  type = "string"
}

variable "from_email" {
  type = "string"
}

variable "from_name" {
  type = "string"
}

variable "idp_name" {
  type = "string"
}

variable "internal_alb_arn" {
  description = "The ARN for the IdP-in-a-Box's internal AWS Application Load Balancer."
  type = "string"
}

variable "internal_alb_dns_name" {
  description = "The DNS name for the IdP-in-a-Box's internal AWS Application Load Balancer."
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
