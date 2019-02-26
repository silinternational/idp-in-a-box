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
 - `ga_tracking_id` - The Google Analytics property id (e.g. UA-12345678-12)
 - `ga_client_id` - Used by Google Analytics to distinguish the user (e.g. IDP-<the idp name>-ID-BROKER)
 - `cpu_cron` - How much CPU to allocate to cron service. Default: `128`
 - `memory_cron` - How much memory to allocate to cron service. Default: `64`
 - `subject_for_invite` - Email subject text for invite emails. Default: `Your new {idpDisplayName} account`
 - `subject_for_mfa_rate_limit` - Email subject text for MFA rate limit emails. Default: `Too many 2-step verification attempts on your {idpDisplayName} account`
 - `subject_for_password_changed` - Email subject text for password changed emails. Default: `Your {idpDisplayName} account password has been changed`
 - `subject_for_welcome` - Email subject text for welcome emails. Default: `Welcome to your new {idpDisplayName} account`
 - `subject_for_get_backup_codes` - Email subject text for get backup codes emails. Default: `Get printable codes for your {idpDisplayName} account`
 - `subject_for_refresh_backup_codes` - Email subject text for refresh backup codes emails. Default: `Get a new set of printable codes for your {idpDisplayName} account`
 - `subject_for_lost_security_key` - Email subject text for lost security key emails. Default: `Have you lost the security key you use with your {idpDisplayName} account?`
 - `subject_for_mfa_option_added` - Email subject text for mfa option added emails. Default: `A 2-Step Verification option was added to your {idpDisplayName} account`
 - `subject_for_mfa_option_removed` - Email subject text for mfa option removed emails. Default: `A 2-Step Verification option was removed from your {idpDisplayName} account`
 - `subject_for_mfa_enabled` - Email subject text for mfa enabled emails. Default: `2-Step Verification was enabled on your {idpDisplayName} account`
 - `subject_for_mfa_disabled` - Email subject text for mfa disabled emails. Default: `2-Step Verification was disabled on your {idpDisplayName} account`
 - `subject_for_mfa_manager` - Email subject text for mfa manager emails. Default: `{displayName} has sent you a login code for their {idpDisplayName} account`
 - `subject_for_method_verify` - Email subject text for method verify emails. Default: `Please verify your new password recovery method`
 - `send_invite_emails` - Bool of whether or not to send invite emails. Default: `true`
 - `send_mfa_rate_limit_emails` - Bool of whether or not to send MFA rate limit emails. Default: `true`
 - `send_password_changed_emails` - Bool of whether or not to send password changed emails. Default: `true`
 - `send_welcome_emails` - Bool of whether or not to send welcome emails. Default: `true`
 - `send_get_backup_codes_emails` - Bool of whether or not to send get backup codes emails. Default: `true`
 - `send_refresh_backup_codes_emails` - Bool of whether or not to send refresh backup codes emails. Default: `true`
 - `send_lost_security_key_emails` - Bool of whether or not to send lost security key emails. Default: `true`
 - `send_mfa_option_added_emails` - Bool of whether or not to send mfa option added emails. Default: `true`
 - `send_mfa_option_removed_emails` - Bool of whether or not to send mfa option removed emails. Default: `true`
 - `send_mfa_enabled_emails` - Bool of whether or not to send mfa enabled emails. Default: `true`
 - `send_mfa_disabled_emails` - Bool of whether or not to send mfa disabled emails. Default: `true`
 - `support_name` - Name for support. Default: `support`
 - `idp_display_name` - Display name for IdP. Default is empty string
 - `mfa_nag_interval` - How often to prompt users on login to setup MFA. Default: `+30 days`
 - `lost_security_key_email_days` - The number of days of not using a security key after which we email the user. Default: `62`
 - `minimum_backup_codes_before_nag` - Nag the user if they have FEWER than this number of backup codes. Default: `4` 
 - `email_repeat_delay_days` - Don't resend the same type of email to the same user for X days. Default: `31`
 - `password_reuse_limit` - Number of passwords to remember for "recent password" restriction. Default: `10`
 - `password_lifespan` - Time span before which the user should set a new password. Default: `+1 year`
 - `password_expiration_grace_period` - Grace period after `password_lifespan` after which the account will be locked. Default: `+30 days`
 - `invite_lifespan` - Time span before the invite code expires. Default: `+1 month`
 - `invite_grace_period` - Grace period after the invite lifespan, after which the invite will be deleted. Default: `+3 months`
 - `mfa_lifetime` - Defines the amount of time in which an MFA must be verified. Default: `+2 hours`
 - `method_lifetime` - Defines the amount of time in which a recovery method must be verified. Default: `+1 day`
 - `method_gracePeriod` - If a recovery method has been expired longer than this amount of time, it will be removed. Default: `+1 week`
 - `method_codeLength` - Number of digits in recovery method verification code. Default: `6`
 - `method_maxAttempts` - Maximum number of recovery method verification attempts allowed. Default: `10`
 - `mfa_add_interval` - Interval between reminders to add MFAs. Default: `+30 days`
 - `mfa_review_interval` - Interval between reminders to review existing MFAs. Default: `+6 months`
 - `method_add_interval` -  Interval between reminders to add recovery methods. Default: `+6 months`
 - `method_review_interval` - Interval between reminders to review existing recovery methods. Default: `+12 months`


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
  ga_tracking_id               = "${var.ga_tracking_id}"
  ga_client_id                 = "${var.ga_client_id}"
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
  mfa_nag_interval             = "${var.mfa_nag_interval}"
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
  send_welcome_emails          = "${var.send_welcome_emails}"
  ssl_policy                   = "${var.ssl_policy}"
  subdomain                    = "${var.broker_subdomain}"
  subject_for_invite           = "${var.subject_for_invite}"
  subject_for_mfa_rate_limit   = "${var.subject_for_mfa_rate_limit}"
  subject_for_password_changed = "${var.subject_for_password_changed}"
  subject_for_welcome          = "${var.subject_for_welcome}"
  support_email                = "${var.support_email}"
  support_name                 = "${var.support_name}"
  vpc_id                       = "${data.terraform_remote_state.cluster.vpc_id}"
  wildcard_cert_arn            = "${data.terraform_remote_state.cluster.wildcard_cert_arn}"
}
```
