# 031-email-service - ECS service for email-service
This module is used to create an ECS service running email-service.

## What this does

 - Create task definition and ECS service for email-service
 - Create Cloudflare DNS record

## Required Inputs

 - `app_env` - Application environment
 - `app_name` - Application name (default: email-service)
 - `cloudflare_domain` - Top level domain name for use with Cloudflare
 - `cpu` - CPU resources to allot to this (default: 250)
 - `db_name` - Name of MySQL database for email-service
 - `desired_count` - Desired count of tasks running in ECS service
 - `docker_image` - The docker image to use for this
 - `ecs_cluster_id` - ID for ECS Cluster
 - `ecsServiceRole_arn` - ARN for ECS Service Role
 - `email_brand_color` - CSS color to use for branding in emails
 - `email_brand_logo` - The fully qualified URL to an image for logo in emails
 - `email_queue_batch_size` - How many queued emails to process per run (default: 10)
 - `from_email` - Email address to send emails from
 - `from_name` - Email address to send emails from
 - `idp_name` - Short name of IdP for use in logs and email alerts
 - `internal_alb_arn` - ARN for the IdP-in-a-Box's internal Application Load Balancer
 - `internal_alb_dns_name` - DNS name for the IdP-in-a-Box's internal Application Load Balancer
 - `internal_alb_listener_arn` - ARN for the IdP-in-a-Box's internal ALB's listener
 - `logentries_set_id` - Logentries logset ID for creating new log in
 - `mailer_host` - SMTP hostname
 - `mailer_password` - SMTP password
 - `mailer_usefiles` - Whether or not YiiMailer should write to files instead of sending emails
 - `mailer_username` - SMTP username
 - `memory` - Memory (RAM) resources to allot to this (default: 96)
 - `mysql_host` - Address for RDS instance
 - `mysql_pass` - MySQL password for email-service
 - `mysql_user` - MySQL username for email-service
 - `notification_email` - Email address to send alerts/notifications to
 - `ssl_policy` - SSL policy
 - `subdomain` - Subdomain for email-service
 - `vpc_id` - ID for VPC
 - `wildcard_cert_arn` - ARN to ACM wildcard certificate


## Outputs

 - `hostname` - The URL to the Email Service
 - `db_emailservice_user` - Email Service MySQL username
 - `access_token_pwmanager` - Access token for PW Manager to use in API calls to Email Service
 - `access_token_idbroker` - Access token for ID Broker to use in API calls to Email Service
 - `access_token_idsync` - Access token for ID Sync to use in API calls to Email Service

## Usage Example

```hcl
module "email" {
  source                  = "github.com/silinternational/idp-in-a-box//terraform/031-email-service"
  app_env                 = "${var.app_env}"
  app_name                = "${var.app_name}"
  cloudflare_domain       = "${var.cloudflare_domain}"
  cpu                     = "${var.cpu}"
  db_name                 = "${var.db_emailservice_name}"
  desired_count           = "${var.ecs_desired_count}"
  docker_image            = "${data.terraform_remote_state.ecr.ecr_repo_emailservice}"
  ecs_cluster_id          = "${data.terraform_remote_state.core.ecs_cluster_id}"
  ecsServiceRole_arn      = "${data.terraform_remote_state.core.ecsServiceRole_arn}"
  email_brand_color       = "${var.email_brand_color}"
  email_brand_logo        = "${var.email_brand_logo}"
  email_queue_batch_size  = "${var.email_queue_batch_size}"
  from_email              = "${var.from_email}"
  from_name               = "${var.from_name}"
  idp_name                = "${var.idp_name}"
  internal_alb_arn        = "${data.terraform_remote_state.cluster.internal_alb_arn}"
  internal_alb_dns_name   = "${data.terraform_remote_state.cluster.internal_alb_dns_name}"
  logentries_set_id       = "${data.terraform_remote_state.cluster.logentries_set_id}"
  mailer_host             = "${var.mailer_host}"
  mailer_password         = "${var.mailer_password}"
  mailer_usefiles         = "${var.mailer_usefiles}"
  mailer_username         = "${var.mailer_username}"
  memory                  = "${var.memory}"
  mysql_host              = "${data.terraform_remote_state.database.rds_address}"
  mysql_pass              = "${data.terraform_remote_state.database.db_emailservice_pass}"
  mysql_user              = "${var.db_emailservice_user}"
  notification_email      = "${var.notification_email}"
  ssl_policy              = "${var.ssl_policy}"
  subdomain               = "${var.email_subdomain}"
  vpc_id                  = "${data.terraform_remote_state.cluster.vpc_id}"
  wildcard_cert_arn       = "${data.terraform_remote_state.cluster.wildcard_cert_arn}"
}
```
