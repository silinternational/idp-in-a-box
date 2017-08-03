# 040-id-broker - ECS service for id-broker
This module is used to create an ECS service running id-broker.

## What this does

 - Create internal ALB for idp-broker
 - Create task definition and ECS service for id-broker
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
 - `db_name` - Name of MySQL database for id-broker
 - `ldap_admin_password` - Password for LDAP user if using migrate passwords feature
 - `ldap_admin_username` - Username for LDAP user if using migrate passwords feature
 - `ldap_base_dn` - Base DN for LDAP queries if using migrate passwords feature
 - `ldap_domain_controllers` - Hostname for LDAP server if using migrate passwords feature
 - `ldap_use_ssl` - true/false
 - `ldap_use_tls` - true/false
 - `mailer_usefiles` - Whether or not YiiMailer should write to files instead of sending emails
 - `mailer_host` - SMTP hostname
 - `mailer_username` - SMTP username
 - `mailer_password` - SMTP password
 - `notification_email` - Email address to send alerts/notifications to
 - `migrate_pw_from_ldap` - Whether or not to attempt to migrate passwords from LDAP
 - `mysql_host` - Address for RDS instance
 - `mysql_user` - MySQL username for id-broker
 - `mysql_pass` - MySQL password for id-broker
 - `ecs_cluster_id` - ID for ECS Cluster
 - `ecsServiceRole_arn` - ARN for ECS Service Role
 - `broker_subdomain` - Subdomain for id-broker
 - `cloudflare_domain` - Top level domain name for use with Cloudflare
 - `desired_count` - Desired count of tasks running in ECS service


## Outputs

 - `hostname` - The url to id-broker
 - `db_idbroker_user` - ID Broker MySQL username
 - `access_token_pwmanager` - Access token for PW Manager to use in API calls to id-broker
 - `access_token_ssp` - Access token for simpleSAMLphp to use in API calls to id-broker
 - `access_token_idsync` - Access token for id-sync to use in API calls to id-broker

## Usage Example

```hcl
module "broker" {
  source                  = "github.com/silinternational/idp-in-a-box//terraform/040-id-broker"
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
  docker_image            = "${data.terraform_remote_state.ecr.ecr_repo_idbroker}"
  db_name                 = "${var.db_idbroker_name}"
  ldap_admin_password     = "${var.ldap_admin_password}"
  ldap_admin_username     = "${var.ldap_admin_username}"
  ldap_base_dn            = "${var.ldap_base_dn}"
  ldap_domain_controllers = "${var.ldap_domain_controllers}"
  ldap_use_ssl            = "${var.ldap_use_ssl}"
  ldap_use_tls            = "${var.ldap_use_tls}"
  mailer_usefiles         = "${var.mailer_usefiles}"
  mailer_host             = "${var.mailer_host}"
  mailer_username         = "${var.mailer_username}"
  mailer_password         = "${var.mailer_password}"
  notification_email      = "${var.notification_email}"
  migrate_pw_from_ldap    = "${var.migrate_pw_from_ldap}"
  mysql_host              = "${data.terraform_remote_state.database.rds_address}"
  mysql_user              = "${var.db_idbroker_user}"
  mysql_pass              = "${data.terraform_remote_state.database.db_idbroker_pass}"
  ecs_cluster_id          = "${data.terraform_remote_state.core.ecs_cluster_id}"
  ecsServiceRole_arn      = "${data.terraform_remote_state.core.ecsServiceRole_arn}"
  subdomain               = "${var.broker_subdomain}"
  cloudflare_domain       = "${var.cloudflare_domain}"
  desired_count           = "${var.ecs_desired_count}"
}
```
