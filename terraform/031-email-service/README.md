# 031-email-service - ECS service for email-service
This module is used to create an ECS service running email-service.

## What this does

 - Create internal ALB for email-service
 - Create task definition and ECS service for email-service
 - Create Cloudflare DNS record

## Required Inputs

 - `app_name` - Application name
 - `app_env` - Application environment
 - `vpc_default_sg_id` - ID for default security group in VPC
 - `private_subnet_ids` - List of private subnet ids
 - `vpc_id` - ID for VPC
 - `ssl_policy` - SSL policy
 - `wildcard_cert_arn` - ARN to ACM wildcard certificate
 - `logentries_set_id` - Logentries logset ID for creating new log in
 - `idp_name` - Short name of IdP for use in logs and email alerts
 - `ecr_repo_emailservice` - ECR repo url for email-service Docker image
 - `db_name` - Name of MySQL database for email-service
 - `mailer_usefiles` - Whether or not YiiMailer should write to files instead of sending emails
 - `mailer_host` - SMTP hostname
 - `mailer_username` - SMTP username
 - `mailer_password` - SMTP password
 - `notification_email` - Email address to send alerts/notifications to
 - `mysql_host` - Address for RDS instance
 - `mysql_user` - MySQL username for email-service
 - `mysql_pass` - MySQL password for email-service
 - `ecs_cluster_id` - ID for ECS Cluster
 - `ecsServiceRole_arn` - ARN for ECS Service Role
 - `email_subdomain` - Subdomain for email-service
 - `cloudflare_domain` - Top level domain name for use with Cloudflare
 - `desired_count` - Desired count of tasks running in ECS service


## Outputs

 - `hostname` - The url to email-service
 - `db_emailservice_user` - Email Service MySQL username
 - `access_token_pwmanager` - Access token for PW Manager to use in API calls to email-service
 - `access_token_idbroker` - Access token for ID Broker to use in API calls to email-service
 - `access_token_idsync` - Access token for id-sync to use in API calls to email-service

## Usage Example

```hcl
module "email" {
  source                  = "github.com/silinternational/idp-in-a-box//terraform/031-email-service"
  memory                  = "${var.memory}"
  cpu                     = "${var.cpu}"
  app_name                = "${var.app_name}"
  app_env                 = "${var.app_env}"
  vpc_default_sg_id       = "${data.terraform_remote_state.cluster.vpc_default_sg_id}"
  private_subnet_ids      = "${data.terraform_remote_state.cluster.private_subnet_ids}"
  vpc_id                  = "${data.terraform_remote_state.cluster.vpc_id}"
  ssl_policy              = "${var.ssl_policy}"
  wildcard_cert_arn       = "${data.terraform_remote_state.cluster.wildcard_cert_arn}"
  logentries_set_id       = "${data.terraform_remote_state.cluster.logentries_set_id}"
  idp_name                = "${var.idp_name}"
  docker_image            = "${data.terraform_remote_state.ecr.ecr_repo_emailservice}"
  db_name                 = "${var.db_emailservice_name}"
  mailer_usefiles         = "${var.mailer_usefiles}"
  mailer_host             = "${var.mailer_host}"
  mailer_username         = "${var.mailer_username}"
  mailer_password         = "${var.mailer_password}"
  notification_email      = "${var.notification_email}"
  mysql_host              = "${data.terraform_remote_state.database.rds_address}"
  mysql_user              = "${var.db_emailservice_user}"
  mysql_pass              = "${data.terraform_remote_state.database.db_emailservice_pass}"
  ecs_cluster_id          = "${data.terraform_remote_state.core.ecs_cluster_id}"
  ecsServiceRole_arn      = "${data.terraform_remote_state.core.ecsServiceRole_arn}"
  subdomain               = "${var.email_subdomain}"
  cloudflare_domain       = "${var.cloudflare_domain}"
  desired_count           = "${var.ecs_desired_count}"
}
```
