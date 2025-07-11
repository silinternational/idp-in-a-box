# 031-email-service - ECS service for email-service
This module is used to create an ECS service running email-service.

# Deprecation notice

This service will be removed in the next major version. It is being replaced by the email service integrated within the
id-broker module. In preparation, upgrade idp-id-broker to version 8.1.0 or later, set the `use_broker_email_service`
variable to "true" in the pw-manager and id-sync module, and define the following variables in the id-broker module:

- email_brand_color
- email_brand_logo
- from_email
- from_name
- enable_email_service
- cpu_email
- memory_email

## What this does

 - Create task definition and ECS service for email-service API
 - Create task definition and ECS service for email-service cron
 - Create Cloudflare DNS record
 - Create ECS task role to send email via SES

## Required Inputs

 - `app_env` - Application environment
 - `cloudflare_domain` - Top level domain name for use with Cloudflare
 - `cloudwatch_log_group_name` - CloudWatch log group name
 - `db_name` - Name of MySQL database for email-service
 - `docker_image` - The docker image to use for this
 - `ecs_cluster_id` - ID for ECS Cluster
 - `ecsServiceRole_arn` - ARN for ECS Service Role
 - `email_brand_color` - CSS color to use for branding in emails
 - `email_brand_logo` - The fully qualified URL to an image for logo in emails
 - `from_email` - Email address to send emails from. See `from_name`
 - `idp_name` - Short name of IdP for use in logs and email alerts
 - `internal_alb_dns_name` - DNS name for the IdP-in-a-Box's internal Application Load Balancer
 - `internal_alb_listener_arn` - ARN for the IdP-in-a-Box's internal ALB's listener
 - `mysql_host` - Address for RDS instance
 - `mysql_pass` - MySQL password for email-service
 - `mysql_user` - MySQL username for email-service
 - `notification_email` - Email address to send alerts/notifications to
 - `subdomain` - Subdomain for email-service
 - `vpc_id` - ID for VPC

## Optional Inputs

 - `app_name` - Application name
 - `cpu_api` - CPU resources to allot to each API instance
 - `cpu_cron` - CPU resources to allot to the cron instance
 - `desired_count_api` - Desired count of email-service API instances (there will only be 1 cron instance)
 - `email_queue_batch_size` - How many queued emails to process per run
 - `enable_cron` - Set to false to disable the cron instance
 - `from_name` - Name to use when sending emails
 - `mailer_host` - SMTP hostname
 - `mailer_password` - SMTP password
 - `mailer_username` - SMTP username
 - `mailer_usefiles` - Whether or not YiiMailer should write to files instead of sending emails
 - `memory_api` - Memory (RAM) resources to allot to each API instance
 - `memory_cron` - Memory (RAM) resources to allot to the cron instance

## Outputs

 - `hostname` - The URL to the Email Service
 - `db_emailservice_user` - Email Service MySQL username
 - `access_token_pwmanager` - Access token for PW Manager to use in API calls to Email Service
 - `access_token_idbroker` - Access token for ID Broker to use in API calls to Email Service
 - `access_token_idsync` - Access token for ID Sync to use in API calls to Email Service

## Usage Example

```hcl
module "email" {
  source                    = "github.com/silinternational/idp-in-a-box//terraform/031-email-service"
  app_env                   = var.app_env
  app_name                  = var.app_name
  cloudflare_domain         = var.cloudflare_domain
  cloudwatch_log_group_name = var.cloudwatch_log_group_name
  cpu_api                   = var.cpu_api
  cpu_cron                  = var.cpu_cron
  db_name                   = var.db_name
  desired_count_api         = var.desired_count_api
  docker_image              = data.terraform_remote_state.ecr.ecr_repo_emailservice
  ecs_cluster_id            = data.terraform_remote_state.core.ecs_cluster_id
  ecsServiceRole_arn        = data.terraform_remote_state.core.ecsServiceRole_arn
  email_brand_color         = var.email_brand_color
  email_brand_logo          = var.email_brand_logo
  email_queue_batch_size    = var.email_queue_batch_size
  from_email                = var.from_email
  idp_name                  = var.idp_name
  internal_alb_dns_name     = data.terraform_remote_state.cluster.internal_alb_dns_name
  internal_alb_listener_arn = data.terraform_remote_state.cluster.internal_alb_https_listener_arn
  mailer_host               = var.mailer_host
  mailer_password           = var.mailer_password
  mailer_usefiles           = var.mailer_usefiles
  mailer_username           = var.mailer_username
  memory_api                = var.memory_api
  memory_cron               = var.memory_cron
  mysql_host                = data.terraform_remote_state.database.rds_address
  mysql_pass                = data.terraform_remote_state.database.db_emailservice_pass
  mysql_user                = var.mysql_user
  notification_email        = var.notification_email
  subdomain                 = var.email_subdomain
  vpc_id                    = data.terraform_remote_state.cluster.vpc_id
}
```
