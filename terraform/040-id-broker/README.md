# 040-id-broker - ECS service for id-broker
This module is used to create an ECS service running id-broker.

## What this does

 - Create internal ALB for idp-broker
 - Create task definition and ECS service for id-broker
 - Create Cloudflare DNS record

## Required Inputs

 - `app_name` - Application name
 - `app_env` - Application environment
 - `vpc_id` - ID for VPC
 - `ssl_policy` - SSL policy
 - `wildcard_cert_arn` - ARN to ACM wildcard certificate
 - `logentries_set_id` - Logentries logset ID for creating new log in
 - `idp_name` - Short name of IdP for use in logs and email alerts
 - `db_name` - Name of MySQL database for id-broker
 - `email_signature` - Signature for use in emails
 - `email_service_accessToken` - Access token for Email Service API
 - `email_service_baseUrl` - Base URL (e.g. 'https://email.example.com') to Email Service API
 - `email_service_validIpRanges` - List of valid IP address ranges for Email Service API
 - `help_center_url` - URL to password manager help center
 - `internal_alb_dns_name` - DNS name for the IdP-in-a-Box's internal Application Load Balancer
 - `internal_alb_listener_arn` - ARN for the IdP-in-a-Box's internal ALB's listener
 - `ldap_admin_password` - Password for LDAP user if using migrate passwords feature
 - `ldap_admin_username` - Username for LDAP user if using migrate passwords feature
 - `ldap_base_dn` - Base DN for LDAP queries if using migrate passwords feature
 - `ldap_domain_controllers` - Hostname for LDAP server if using migrate passwords feature
 - `ldap_use_ssl` - true/false
 - `ldap_use_tls` - true/false
 - `mfa_totp_apibaseurl` - Base URL to TOTP api
 - `mfa_totp_apikey` - API key for TOTP api
 - `mfa_totp_apisecret` - API secret for TOTP api
 - `mfa_u2f_apibaseurl` - Base URL for U2F api
 - `mfa_u2f_apikey` - API key for U2F api
 - `mfa_u2f_apisecret` - API secret for U2F api
 - `mfa_u2f_appid` - AppID for U2F api
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
 - `password_forgot_url` - URL to forgot password process
 - `password_profile_url` - URL to password manager profile
 - `support_email` - Email address for support

## Optional Inputs

 - `email_service_assertValidIp` - Whether or not to assert IP address for Email Service API is trusted
 - `cpu_cron` - How much CPU to allocate to cron service. Default: `128`
 - `memory_cron` - How much memory to allocate to cron service. Default: `64`
 - `subject_for_invite` - Email subject text for invite emails. Default: `Your new %s account`
 - `subject_for_mfa_rate_limit` - Email subject text for MFA rate limit emails. Default: `Too many 2-step verification attempts on your %s account`
 - `subject_for_password_changed` - Email subject text for password changed emails. Default: `Your %s account password has been changed`
 - `send_invite_emails` - Bool of whether or not to send invite emails. Default: `false`
 - `send_mfa_rate_limit_emails` - Bool of whether or not to send MFA rate limit emails. Default: `true`
 - `send_password_changed_emails` - Bool of whether or not to send password changed emails. Default: `true`
 - `support_name` - Name for support. Default: `support`


## Outputs

 - `hostname` - The url to id-broker
 - `db_idbroker_user` - ID Broker MySQL username
 - `access_token_pwmanager` - Access token for PW Manager to use in API calls to id-broker
 - `access_token_ssp` - Access token for simpleSAMLphp to use in API calls to id-broker
 - `access_token_idsync` - Access token for id-sync to use in API calls to id-broker

## Usage Example

```hcl
module "broker" {
  source                       = "github.com/silinternational/idp-in-a-box//terraform/040-id-broker"
  app_env                      = "${var.app_env}"
  app_name                     = "${var.app_name}"
  cloudflare_domain            = "${var.cloudflare_domain}"
  cpu                          = "${var.cpu}"
  cpu_cron                     = "${var.cpu_cron}"
  desired_count                = "${var.desired_count}"
  db_name                      = "${var.db_name}"
  docker_image                 = "${data.terraform_remote_state.ecr.ecr_repo_idbroker}"
  ecs_cluster_id               = "${data.terraform_remote_state.core.ecs_cluster_id}"
  ecsServiceRole_arn           = "${data.terraform_remote_state.core.ecsServiceRole_arn}"
  email_service_accessToken    = "${data.terraform_remote_state.email.access_token_idbroker}"
  email_service_assertValidIp  = "${var.email_service_assertValidIp}"
  email_service_baseUrl        = "https://${data.terraform_remote_state.email.hostname}"
  email_service_validIpRanges  = ["${data.terraform_remote_state.cluster.private_subnet_cidr_blocks}"]
  email_signature              = "${var.email_signature}"
  help_center_url              = "${var.help_center_url}"
  idp_name                     = "${var.idp_name}"
  internal_alb_dns_name        = "${data.terraform_remote_state.cluster.internal_alb_dns_name}"
  internal_alb_listener_arn    = "${data.terraform_remote_state.cluster.internal_alb_https_listener_arn}"
  ldap_admin_password          = "${var.ldap_admin_password}"
  ldap_admin_username          = "${var.ldap_admin_username}"
  ldap_base_dn                 = "${var.ldap_base_dn}"
  ldap_domain_controllers      = "${var.ldap_domain_controllers}"
  ldap_use_ssl                 = "${var.ldap_use_ssl}"
  ldap_use_tls                 = "${var.ldap_use_tls}"
  logentries_set_id            = "${data.terraform_remote_state.cluster.logentries_set_id}"
  memory                       = "${var.memory}"
  memory_cron                  = "${var.memory_cron}"
  mfa_totp_apibaseurl          = "${var.mfa_totp_apibaseurl}"
  mfa_totp_apikey              = "${var.mfa_totp_apikey}"
  mfa_totp_apisecret           = "${var.mfa_totp_apisecret}"
  mfa_u2f_apibaseurl           = "${var.mfa_u2f_apibaseurl}"
  mfa_u2f_apikey               = "${var.mfa_u2f_apikey}"
  mfa_u2f_apisecret            = "${var.mfa_u2f_apisecret}"
  mfa_u2f_appid                = "${var.mfa_u2f_appid}"
  migrate_pw_from_ldap         = "${var.migrate_pw_from_ldap}"
  mysql_host                   = "${data.terraform_remote_state.database.rds_address}"
  mysql_user                   = "${var.mysql_user}"
  mysql_pass                   = "${data.terraform_remote_state.database.db_idbroker_pass}"
  notification_email           = "${var.notification_email}"
  password_forgot_url          = "${var.password_forgot_url}"
  password_profile_url         = "${var.password_profile_url}"
  send_invite_emails           = "${var.send_invite_emails}"
  send_mfa_rate_limit_emails   = "${var.send_mfa_rate_limit_emails}"
  send_password_changed_emails = "${var.send_password_changed_emails}"
  ssl_policy                   = "${var.ssl_policy}"
  subdomain                    = "${var.broker_subdomain}"
  subject_for_invite           = "${var.subject_for_invite}"
  subject_for_mfa_rate_limit   = "${var.subject_for_mfa_rate_limit}"
  subject_for_password_changed = "${var.subject_for_password_changed}"
  support_email                = "${var.support_email}"
  support_name                 = "${var.support_name}"
  vpc_id                       = "${data.terraform_remote_state.cluster.vpc_id}"
  wildcard_cert_arn            = "${data.terraform_remote_state.cluster.wildcard_cert_arn}"
}
```
