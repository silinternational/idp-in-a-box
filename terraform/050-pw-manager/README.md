# 050-pw-manager - ECS service for password manager API and S3 config for UI
This module is used to create an ECS service running the password manager API and static site hosting for the UI. 

## What this does

 - Create ALB target group for API with hostname based routing
 - Create task definition and ECS service for password manager API and Cron services
 - Create S3 bucket for UI
 - Create CloudFront distribution to provide SSL support for UI
 - Create Cloudflare DNS records for API and UI

## Required Inputs

 - `app_name` - Application name
 - `app_env` - Application environment
 - `logentries_set_id` - Logentries logset ID for creating new log in
 - `vpc_id` - ID for VPC
 - `alb_https_listener_arn` - ARN for ALB HTTPS listener
 - `api_subdomain` - Subdomain for pw manager api
 - `cloudflare_domain` - Top level domain name for use with Cloudflare
 - `idp_name` - Short name of IdP for use in logs and email alerts
 - `alerts_email` - Email address to send alerts/notifications to
 - `support_email` - Email address for end user support
 - `from_email` - Email from address
 - `from_name` - Email from name
 - `logo_url` - URL that logo should link to
 - `mailer_usefiles` - Whether or not YiiMailer should write to files instead of sending emails
 - `mailer_host` - SMTP hostname
 - `mailer_username` - SMTP username
 - `mailer_password` - SMTP password
 - `db_name` - Name of MySQL database for pw-api
 - `mysql_host` - Address for RDS instance
 - `mysql_user` - MySQL username for id-broker
 - `mysql_pass` - MySQL password for id-broker
 - `recaptcha_key` - Recaptcha site key
 - `recaptcha_secret` - Recaptcha secret
 - `docker_image` - URL to Docker image
 - `ui_subdomain` - Subdomain for PW UI
 - `id_broker_access_token` - Access token for calling id-broker
 - `id_broker_base_uri` - Base URL to id-broker API
 - `ecs_cluster_id` - ID for ECS Cluster
 - `ecsServiceRole_arn` - ARN for ECS Service Role
 - `alb_dns_name` - DNS name for application load balancer 
 - `wildcard_cert_arn` - ARN to ACM wildcard cert

## Outputs

 - `ui_bucket` - ARN for S3 bucket for UI
 - `cloudfront_distribution_id` - Cloudfront distribution ID
 - `ui_hostname` - Full hostname for UI
 - `api_hostname` - Full hostname for API
 - `db_pwmanager_user` - Username for mysql

## Usage Example

```hcl
module "pwmanager" {
  source = "github.com/silinternational/idp-in-a-box//terraform/050-pw-manager"
  app_name = "${var.app_name}"
  app_env = "${var.app_env}"
  logentries_set_id = "${data.terraform_remote_state.cluster.logentries_set_id}"
  vpc_id = "${data.terraform_remote_state.cluster.vpc_id}"
  alb_https_listener_arn = "${data.terraform_remote_state.cluster.alb_https_listener_arn}"
  api_subdomain = "${var.api_subdomain}"
  cloudflare_domain = "${var.cloudflare_domain}"
  idp_name = "${var.idp_name}"
  alerts_email = "${var.alerts_email}"
  support_email = "${var.support_email}"
  from_email = "${var.from_email}"
  from_name = "${var.from_name}"
  logo_url = "${var.logo_url}"
  mailer_usefiles = "${var.mailer_usefiles}"
  mailer_host = "${var.mailer_host}"
  mailer_username = "${var.mailer_username}"
  mailer_password = "${var.mailer_password}"
  db_name = "${var.db_pwmanager_name}"
  mysql_host = "${data.terraform_remote_state.database.rds_address}"
  mysql_user = "${var.db_pwmanager_user}"
  mysql_pass = "${data.terraform_remote_state.database.db_pwmanager_pass}"
  recaptcha_key = "${var.recaptcha_key}"
  recaptcha_secret = "${var.recaptcha_secret}"
  docker_image = "${data.terraform_remote_state.ecr.ecr_repo_pwmanager}"
  ui_subdomain = "${var.ui_subdomain}"
  id_broker_access_token = "${data.terraform_remote_state.broker.access_token_pwmanager}"
  id_broker_base_uri = "https://${data.terraform_remote_state.broker.hostname}"
  ecs_cluster_id = "${data.terraform_remote_state.core.ecs_cluster_id}"
  ecsServiceRole_arn = "${data.terraform_remote_state.core.ecsServiceRole_arn}"
  alb_dns_name = "${data.terraform_remote_state.cluster.alb_dns_name}"
  wildcard_cert_arn = "${data.terraform_remote_state.cluster.wildcard_cert_arn}"
  cd_user_username = "${data.terraform_remote_state.core.cduser_username}"
}
```
