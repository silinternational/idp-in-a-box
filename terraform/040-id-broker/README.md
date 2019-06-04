# 040-id-broker - ECS service for id-broker
This module is used to create an ECS service running id-broker.

## What this does

 - Create internal ALB for idp-broker
 - Create task definition and ECS service for id-broker
 - Create Cloudflare DNS record

## Required Inputs

 - `app_env` - Application environment
 - `app_name` - Application name
 - `broker_subdomain` - Subdomain for id-broker
 - `cloudflare_domain` - Top level domain name for use with Cloudflare
 - `db_name` - Name of MySQL database for id-broker
 - `desired_count` - Desired count of tasks running in ECS service
 - `ecs_cluster_id` - ID for ECS Cluster
 - `ecsServiceRole_arn` - ARN for ECS Service Role
 - `email_service_accessToken` - Access token for Email Service API
 - `email_service_baseUrl` - Base URL (e.g. 'https://email.example.com') to Email Service API
 - `email_service_validIpRanges` - List of valid IP address ranges for Email Service API
 - `help_center_url` - URL to password manager help center
 - `idp_name` - Short name of IdP for use in logs and email alerts
 - `internal_alb_dns_name` - DNS name for the IdP-in-a-Box's internal Application Load Balancer
 - `internal_alb_listener_arn` - ARN for the IdP-in-a-Box's internal ALB's listener
 - `logentries_set_id` - Logentries logset ID for creating new log in
 - `mfa_totp_apibaseurl` - Base URL to TOTP api
 - `mfa_totp_apikey` - API key for TOTP api
 - `mfa_totp_apisecret` - API secret for TOTP api
 - `mfa_u2f_apibaseurl` - Base URL for U2F api
 - `mfa_u2f_apikey` - API key for U2F api
 - `mfa_u2f_apisecret` - API secret for U2F api
 - `mfa_u2f_appid` - AppID for U2F api
 - `mysql_host` - Address for RDS instance
 - `mysql_pass` - MySQL password for id-broker
 - `mysql_user` - MySQL username for id-broker
 - `password_profile_url` - URL to password manager profile
 - `ssl_policy` - SSL policy
 - `support_email` - Email address for support
 - `support_name` - Name for support. Default: `support`
 - `vpc_id` - ID for VPC
 - `wildcard_cert_arn` - ARN to ACM wildcard certificate

## Optional Inputs

 - `contingent_user_duration` - How long before a new user without a primary email address expires. Default: `+4 weeks`
 - `cpu_cron` - How much CPU to allocate to cron service. Default: `128`
 - `email_repeat_delay_days` - Don't resend the same type of email to the same user for X days. Default: `31`
 - `email_service_assertValidIp` - Whether or not to assert IP address for Email Service API is trusted
 - `email_signature` - Signature for use in emails. Default is empty string
 - `ga_client_id` - Used by Google Analytics to distinguish the user (e.g. IDP-<the idp name>-ID-BROKER)
 - `ga_tracking_id` - The Google Analytics property id (e.g. UA-12345678-12)
 - `idp_display_name` - Display name for IdP. Default is empty string
 - `invite_grace_period` - Grace period after the invite lifespan, after which the invite will be deleted. Default: `+3 months`
 - `invite_lifespan` - Time span before the invite code expires. Default: `+1 month`
 - `ldap_admin_password` - Password for LDAP user if using migrate passwords feature. Required if `migrate_pw_from_ldap` is true. 
 - `ldap_admin_username` - Username for LDAP user if using migrate passwords feature. Required if `migrate_pw_from_ldap` is true.
 - `ldap_base_dn` - Base DN for LDAP queries if using migrate passwords feature. Required if `migrate_pw_from_ldap` is true.
 - `ldap_domain_controllers` - Hostname for LDAP server if using migrate passwords feature. Required if `migrate_pw_from_ldap` is true.
 - `ldap_use_ssl` - true/false. Required if `migrate_pw_from_ldap` is true.
 - `ldap_use_tls` - true/false. Required if `migrate_pw_from_ldap` is true.
 - `lost_security_key_email_days` - The number of days of not using a security key after which we email the user. Default: `62`
 - `memory_cron` - How much memory to allocate to cron service. Default: `64`
 - `method_add_interval` Interval between reminders to add recovery methods. Default: `+6 months`
 - `method_codeLength` - Number of digits in recovery method verification code. Default: `6`
 - `method_gracePeriod` - If a recovery method has been expired longer than this amount of time, it will be removed. Default: `+1 week`
 - `method_lifetime` - Defines the amount of time in which a recovery method must be verified. Default: `+1 day`
 - `method_maxAttempts` - Maximum number of recovery method verification attempts allowed. Default: `10`
 - `mfa_add_interval` - Interval between reminders to add MFAs. Default: `+30 days`
 - `migrate_pw_from_ldap` - Whether or not to attempt to migrate passwords from LDAP. Default: `false`
 - `mfa_lifetime` - Defines the amount of time in which an MFA must be verified. Default: `+2 hours`
 - `minimum_backup_codes_before_nag` - Nag the user if they have FEWER than this number of backup codes. Default: `4` 
 - `notification_email` - Email address to send alerts/notifications to. Default: notifications disabled
 - `password_expiration_grace_period` - Grace period after `password_lifespan` after which the account will be locked. Default: `+30 days`
 - `password_lifespan` - Time span before which the user should set a new password. Default: `+1 year`
 - `password_mfa_lifespan_extension` - Extension to password lifespan for users with at least one 2-step Verification option. Default: `+4 years`
 - `password_reuse_limit` - Number of passwords to remember for "recent password" restriction. Default: `10`
 - `profile_review_interval` - Interval between reminders to review. Default: `+6 months`
 - `send_get_backup_codes_emails` - Bool of whether or not to send get backup codes emails. Default: `true`
 - `send_invite_emails` - Bool of whether or not to send invite emails. Default: `true`
 - `send_lost_security_key_emails` - Bool of whether or not to send lost security key emails. Default: `true`
 - `send_mfa_disabled_emails` - Bool of whether or not to send mfa disabled emails. Default: `true`
 - `send_mfa_enabled_emails` - Bool of whether or not to send mfa enabled emails. Default: `true`
 - `send_mfa_option_added_emails` - Bool of whether or not to send mfa option added emails. Default: `true`
 - `send_mfa_option_removed_emails` - Bool of whether or not to send mfa option removed emails. Default: `true`
 - `send_mfa_rate_limit_emails` - Bool of whether or not to send MFA rate limit emails. Default: `true`
 - `send_password_changed_emails` - Bool of whether or not to send password changed emails. Default: `true`
 - `send_refresh_backup_codes_emails` - Bool of whether or not to send refresh backup codes emails. Default: `true`
 - `send_welcome_emails` - Bool of whether or not to send welcome emails. Default: `true`
 - `subject_for_get_backup_codes` - Email subject text for get backup codes emails. Default: `Get printable codes for your {idpDisplayName} Identity account`
 - `subject_for_invite` - Email subject text for invite emails. Default: `Your new {idpDisplayName} Identity account`
 - `subject_for_lost_security_key` - Email subject text for lost security key emails. Default: `Have you lost the security key you use with your {idpDisplayName} Identity account?`
 - `subject_for_method_purged` - Email subject text for method purged emails. Default: `An unverified password recovery method has been removed from your {idpDisplayName} Identity account`
 - `subject_for_method_reminder` - Email subject text for method reminder emails. Default: `REMINDER: Please verify your new password recovery method`
 - `subject_for_method_verify` - Email subject text for method verify emails. Default: `Please verify your new password recovery method`
 - `subject_for_mfa_disabled` - Email subject text for mfa disabled emails. Default: `2-Step Verification was disabled on your {idpDisplayName} Identity account`
 - `subject_for_mfa_enabled` - Email subject text for mfa enabled emails. Default: `2-Step Verification was enabled on your {idpDisplayName} Identity account`
 - `subject_for_mfa_manager` - Email subject text for mfa manager emails. Default: `{displayName} has sent you a login code for their {idpDisplayName} Identity account`
 - `subject_for_mfa_manager_help` - Email subject text for mfa manager help emails. Default: `An access code for your {idpDisplayName} Identity account has been sent to your manager`
 - `subject_for_mfa_option_added` - Email subject text for mfa option added emails. Default: `A 2-Step Verification option was added to your {idpDisplayName} Identity account`
 - `subject_for_mfa_option_removed` - Email subject text for mfa option removed emails. Default: `A 2-Step Verification option was removed from your {idpDisplayName} Identity account`
 - `subject_for_mfa_rate_limit` - Email subject text for MFA rate limit emails. Default: `Too many 2-step verification attempts on your {idpDisplayName} Identity account`
 - `subject_for_password_changed` - Email subject text for password changed emails. Default: `Your {idpDisplayName} Identity account password has been changed`
 - `subject_for_password_expired` - Email subject text for password expired emails. Default: `Your {idpDisplayName} Identity account password has expired`
 - `subject_for_password_expiring` - Email subject text for password expiring emails. Default: `The password for your {idpDisplayName} Identity account is about to expire`
 - `subject_for_refresh_backup_codes` - Email subject text for refresh backup codes emails. Default: `Get a new set of printable codes for your {idpDisplayName} Identity account`
 - `subject_for_welcome` - Email subject text for welcome emails. Default: `Welcome to your new {idpDisplayName} Identity account`
 - `user_inactive_period` - Time a user record can remain inactive before being deleted. Default: `+18 months`


## Outputs

 - `hostname` - The url to id-broker
 - `db_idbroker_user` - ID Broker MySQL username
 - `access_token_pwmanager` - Access token for PW Manager to use in API calls to id-broker
 - `access_token_ssp` - Access token for simpleSAMLphp to use in API calls to id-broker
 - `access_token_idsync` - Access token for id-sync to use in API calls to id-broker
 - `help_center_url` - URL for general user help information
 - `email_signature` - Text for use as the signature line of emails.
 - `support_email` - Email for support.
 - `support_name` - Name for support.

## Usage Example

```hcl
module "broker" {
  source                           = "github.com/silinternational/idp-in-a-box//terraform/040-id-broker"
  app_env                          = "${var.app_env}"
  app_name                         = "${var.app_name}"
  cloudflare_domain                = "${var.cloudflare_domain}"
  contingent_user_duration         = "${var.contingent_user_duration}"
  cpu                              = "${var.cpu}"
  cpu_cron                         = "${var.cpu_cron}"
  db_name                          = "${var.db_name}"
  desired_count                    = "${var.desired_count}"
  docker_image                     = "${data.terraform_remote_state.ecr.ecr_repo_idbroker}"
  email_repeat_delay_days          = "${var.email_repeat_delay_days}"
  ecs_cluster_id                   = "${data.terraform_remote_state.core.ecs_cluster_id}"
  ecsServiceRole_arn               = "${data.terraform_remote_state.core.ecsServiceRole_arn}"
  email_service_accessToken        = "${data.terraform_remote_state.email.access_token_idbroker}"
  email_service_assertValidIp      = "${var.email_service_assertValidIp}"
  email_service_baseUrl            = "https://${data.terraform_remote_state.email.hostname}"
  email_service_validIpRanges      = ["${data.terraform_remote_state.cluster.private_subnet_cidr_blocks}"]
  email_signature                  = "${var.email_signature}"
  ga_client_id                     = "${var.ga_client_id}"
  ga_tracking_id                   = "${var.ga_tracking_id}"
  help_center_url                  = "${var.help_center_url}"
  idp_display_name                 = "${var.idp_display_name}"
  idp_name                         = "${var.idp_name}"
  internal_alb_dns_name            = "${data.terraform_remote_state.cluster.internal_alb_dns_name}"
  internal_alb_listener_arn        = "${data.terraform_remote_state.cluster.internal_alb_https_listener_arn}"
  invite_grace_period              = "${var.invite_grace_period}"
  invite_lifespan                  = "${var.invite_lifespan}"
  ldap_admin_password              = "${var.ldap_admin_password}"
  ldap_admin_username              = "${var.ldap_admin_username}"
  ldap_base_dn                     = "${var.ldap_base_dn}"
  ldap_domain_controllers          = "${var.ldap_domain_controllers}"
  ldap_use_ssl                     = "${var.ldap_use_ssl}"
  ldap_use_tls                     = "${var.ldap_use_tls}"
  logentries_set_id                = "${data.terraform_remote_state.cluster.logentries_set_id}"
  lost_security_key_email_days     = "${var.lost_security_key_email_days}"
  memory                           = "${var.memory}"
  memory_cron                      = "${var.memory_cron}"
  method_codeLength                = "${var.method_codeLength}"
  method_gracePeriod               = "${var.method_gracePeriod}"
  method_lifetime                  = "${var.method_lifetime}"
  method_maxAttempts               = "${var.method_maxAttempts}"
  mfa_lifetime                     = "${var.mfa_lifetime}"
  mfa_totp_apibaseurl              = "${var.mfa_totp_apibaseurl}"
  mfa_totp_apikey                  = "${var.mfa_totp_apikey}"
  mfa_totp_apisecret               = "${var.mfa_totp_apisecret}"
  mfa_u2f_apibaseurl               = "${var.mfa_u2f_apibaseurl}"
  mfa_u2f_apikey                   = "${var.mfa_u2f_apikey}"
  mfa_u2f_apisecret                = "${var.mfa_u2f_apisecret}"
  mfa_u2f_appid                    = "${var.mfa_u2f_appid}"
  migrate_pw_from_ldap             = "${var.migrate_pw_from_ldap}"
  minimum_backup_codes_before_nag  = "${var.minimum_backup_codes_before_nag}"
  mysql_host                       = "${data.terraform_remote_state.database.rds_address}"
  mysql_pass                       = "${data.terraform_remote_state.database.db_idbroker_pass}"
  mysql_user                       = "${var.mysql_user}"
  notification_email               = "${var.notification_email}"
  password_expiration_grace_period = "${var.password_expiration_grace_period}"
  password_lifespan                = "${var.password_lifespan}"
  password_mfa_lifespan_extension  = "${var.password_mfa_lifespan_extension}"
  password_profile_url             = "${var.password_profile_url}"
  password_reuse_limit             = "${var.password_reuse_limit}"
  profile_review_interval          = "${var.profile_review_interval}"
  send_get_backup_codes_emails     = "${var.send_get_backup_codes_emails}"
  send_invite_emails               = "${var.send_invite_emails}"
  send_lost_security_key_emails    = "${var.send_lost_security_key_emails}"
  send_method_purged_emails        = "${var.send_method_purged_emails}"
  send_method_reminder_emails      = "${var.send_method_reminder_emails}"
  send_mfa_disabled_emails         = "${var.send_mfa_disabled_emails}"
  send_mfa_enabled_emails          = "${var.send_mfa_enabled_emails}"
  send_mfa_option_added_emails     = "${var.send_mfa_option_added_emails}"
  send_mfa_option_removed_emails   = "${var.send_mfa_option_removed_emails}"
  send_mfa_rate_limit_emails       = "${var.send_mfa_rate_limit_emails}"
  send_password_changed_emails     = "${var.send_password_changed_emails}"
  send_password_expired_emails     = "${var.send_password_expired_emails}"
  send_password_expiring_emails    = "${var.send_password_expiring_emails}"
  send_refresh_backup_codes_emails = "${var.send_refresh_backup_codes_emails}"
  send_welcome_emails              = "${var.send_welcome_emails}"
  ssl_policy                       = "${var.ssl_policy}"
  subdomain                        = "${var.broker_subdomain}"
  subject_for_get_backup_codes     = "${var.subject_for_get_backup_codes}"
  subject_for_invite               = "${var.subject_for_invite}"
  subject_for_lost_security_key    = "${var.subject_for_lost_security_key}"
  subject_for_method_purged        = "${var.subject_for_method_purged}"
  subject_for_method_reminder      = "${var.subject_for_method_reminder}"
  subject_for_method_verify        = "${var.subject_for_method_verify}"
  subject_for_mfa_disabled         = "${var.subject_for_mfa_disabled}"
  subject_for_mfa_enabled          = "${var.subject_for_mfa_enabled}"
  subject_for_mfa_manager          = "${var.subject_for_mfa_manager}"
  subject_for_mfa_manager_help     = "${var.subject_for_mfa_manager_help}"
  subject_for_mfa_option_added     = "${var.subject_for_mfa_option_added}"
  subject_for_mfa_option_removed   = "${var.subject_for_mfa_option_removed}"
  subject_for_mfa_rate_limit       = "${var.subject_for_mfa_rate_limit}"
  subject_for_password_changed     = "${var.subject_for_password_changed}"
  subject_for_password_expired     = "${var.subject_for_password_expired}"
  subject_for_password_expiring    = "${var.subject_for_password_expiring}"
  subject_for_refresh_backup_codes = "${var.subject_for_refresh_backup_codes}"
  subject_for_welcome              = "${var.subject_for_welcome}"
  support_email                    = "${var.support_email}"
  support_name                     = "${var.support_name}"
  user_inactive_period             = "${var.user_inactive_period}"
  vpc_id                           = "${data.terraform_remote_state.cluster.vpc_id}"
  wildcard_cert_arn                = "${data.terraform_remote_state.cluster.wildcard_cert_arn}"
}
```
