# 040-id-broker - ECS service for id-broker
This module is used to create an ECS service running id-broker.

## What this does

 - Create internal ALB for idp-broker
 - Create task definition and ECS service for id-broker
 - Create Cloudflare DNS record

## Required Inputs

 - `app_env` - Application environment
 - `app_name` - Application name
 - `aws_region` - AWS region
 - `cloudflare_domain` - Top level domain name for use with Cloudflare
 - `cloudwatch_log_group_name` - CloudWatch log group name
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
 - `mfa_totp_apibaseurl` - Base URL to TOTP api
 - `mfa_totp_apikey` - API key for TOTP api
 - `mfa_totp_apisecret` - API secret for TOTP api
 - `mfa_webauthn_apibaseurl` - Base URL for WebAuthn api
 - `mfa_webauthn_apikey` - API key for WebAuthn api
 - `mfa_webauthn_apisecret` - API secret for WebAuthn api
 - `mfa_webauthn_appid` - AppID for WebAuthn api
 - `mfa_webauthn_rpdisplayname` - Relying Party Display Name
 - `mfa_webauthn_rpid` - Relying Party ID 
 - `rp_origins` - CSV list of allowed Relying Party Origins
 - `mysql_host` - Address for RDS instance
 - `mysql_pass` - MySQL password for id-broker
 - `mysql_user` - MySQL username for id-broker
 - `password_profile_url` - URL to password manager profile
 - `ssl_policy` - SSL policy
 - `subdomain` - Subdomain to use for this (id-broker) ECS service
 - `support_email` - Email address for support
 - `support_name` - Name for support. Default: `support`
 - `vpc_id` - ID for VPC
 - `wildcard_cert_arn` - ARN to ACM wildcard certificate

## Optional Inputs

 - `abandoned_user_abandoned_period` - Time a user record can remain abandoned before HR is notified. Default: `+6 months`
 - `abandoned_user_best_practice_url` - URL for best practices, referenced in notification email. Default: (none)
 - `abandoned_user_deactivate_instructions_url` - URL for instruction on how to deactivate user accounts, referenced in notification email. Default: (none)
 - `contingent_user_duration` - How long before a new user without a primary email address expires. Default: `+4 weeks`
 - `cpu_cron` - How much CPU to allocate to cron service. Default: `128`
 - `email_repeat_delay_days` - Don't resend the same type of email to the same user for X days. Default: `31`
 - `email_service_assertValidIp` - Whether or not to assert IP address for Email Service API is trusted
 - `email_signature` - Signature for use in emails. Default is empty string
 - `event_schedule` - Task run schedule. Default: `cron(0 0 * * ? *)`
 - `ga_api_secret` - The Google Analytics API secret for the data stream (e.g. aB-abcdef7890123456789)
 - `ga_client_id` - Used by Google Analytics to distinguish the user (e.g. IDP-<the idp name>-ID-BROKER)
 - `ga_measurement_id` - The Google Analytics data stream id (e.g. G-ABCDE67890)
 - `google_config` - A JSON object containing Google properties for Sheets export
 - `hibp_check_interval` - How often should HIBP be checked during login. Default `+1 week`
 - `hibp_check_on_login` - Whether to check HIBP during login. Default `true` 
 - `hibp_grace_period` - How long to set grace period when a pwned password is discovered and force expired. Default: `+1 week`
 - `hibp_tracking_only` - Whether to actually apply changes or just track when pwned passwords are discovered. Default: `false`
 - `hibp_notification_bcc` - An optional email address to BCC pwned password alert emails to.
 - `hr_notifications_email` - If this is defined, HR notification emails (e.g. abandoned user account) will be sent here. Default (none)
 - `idp_display_name` - Display name for IdP. Default is empty string
 - `inactive_user_period` - Time a user record can remain inactive before being deleted. Default: `+18 months`
 - `inactive_user_deletion_enable` - Enable deletion of inactive users after a period defined by inactive_user_period. Default: `false`
 - `invite_email_delay_seconds` - How long to delay new user invite email. Default is 0 (no delay)
 - `invite_grace_period` - Grace period after the invite lifespan, after which the invite will be deleted. Default: `+3 months`
 - `invite_lifespan` - Time span before the invite code expires. Default: `+1 month`
 - `lost_security_key_email_days` - The number of days of not using a security key after which we email the user. Default: `62`
 - `memory_cron` - How much memory to allocate to cron service. Default: `64`
 - `method_add_interval` Interval between reminders to add recovery methods. Default: `+6 months`
 - `method_codeLength` - Number of digits in recovery method verification code. Default: `6`
 - `method_gracePeriod` - If a recovery method has been expired longer than this amount of time, it will be removed. Default: `+1 week`
 - `method_lifetime` - Defines the amount of time in which a recovery method must be verified. Default: `+1 day`
 - `method_maxAttempts` - Maximum number of recovery method verification attempts allowed. Default: `10`
 - `mfa_add_interval` - Interval between reminders to add MFAs. Default: `+30 days`
 - `mfa_allow_disable` - If false, `require_mfa` cannot be set to "no" for any user. Default: `true`
 - `mfa_lifetime` - Defines the amount of time in which an MFA must be verified. Default: `+2 hours`
 - `mfa_manager_bcc` - Email address to bcc on the manager mfa email. Default: ``
 - `mfa_manager_help_bcc` - Email address to bcc on the manager mfa help email. Default: ``
 - `mfa_required_for_new_users` - Require MFA for all new users. Default: `false`
 - `minimum_backup_codes_before_nag` - Nag the user if they have FEWER than this number of backup codes. Default: `4` 
 - `notification_email` - Email address to send alerts/notifications to. Default: notifications disabled
 - `password_expiration_grace_period` - Grace period after `password_lifespan` after which the account will be locked. Default: `+30 days`
 - `password_lifespan` - Time span before which the user should set a new password. Default: `+1 year`
 - `password_mfa_lifespan_extension` - Extension to password lifespan for users with at least one 2-step Verification option. Default: `+4 years`
 - `password_reuse_limit` - Number of passwords to remember for "recent password" restriction. Default: `10`
 - `profile_review_interval` - Interval between reminders to review. Default: `+6 months`
 - `run_task` - Task to run on the schedule defined by `event_schedule`. Default: `cron/all`
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
 - `sentry_dsn` - Sentry DSN for error logging and alerting. Obtain from Sentry dashboard: Settings - Projects - (project) - Client Keys
 - `subject_for_abandoned_users` - Email subject text for abandoned user emails. Default: `Unused {idpDisplayName} Identity Accounts`
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
  app_env                          = var.app_env
  app_name                         = var.app_name
  aws_region                       = var.aws_region
  cloudflare_domain                = var.cloudflare_domain
  cloudwatch_log_group_name        = var.cloudwatch_log_group_name
  contingent_user_duration         = var.contingent_user_duration
  cpu                              = var.cpu
  cpu_cron                         = var.cpu_cron
  db_name                          = var.db_name
  desired_count                    = var.desired_count
  docker_image                     = data.terraform_remote_state.ecr.ecr_repo_idbroker
  email_repeat_delay_days          = var.email_repeat_delay_days
  ecs_cluster_id                   = data.terraform_remote_state.core.ecs_cluster_id
  ecsServiceRole_arn               = data.terraform_remote_state.core.ecsServiceRole_arn
  email_service_accessToken        = data.terraform_remote_state.email.access_token_idbroker
  email_service_assertValidIp      = var.email_service_assertValidIp
  email_service_baseUrl            = "https://${data.terraform_remote_state.email.hostname}"
  email_service_validIpRanges      = data.terraform_remote_state.cluster.private_subnet_cidr_blocks
  email_signature                  = var.email_signature
  event_schedule                   = "cron(1 0 * * ? 0)"
  ga_api_secret                    = var.ga_api_secret
  ga_client_id                     = var.ga_client_id
  ga_measurement_id                = var.ga_measurement_id
  google_config                    = var.google_config
  help_center_url                  = var.help_center_url
  hibp_check_interval              = var.hibp_check_interval
  hibp_check_on_login              = var.hibp_check_on_login
  hibp_grace_period                = var.hibp_grace_period
  hibp_tracking_only               = var.hibp_tracking_only
  hibp_notification_bcc            = var.hibp_notification_bcc
  idp_display_name                 = var.idp_display_name
  idp_name                         = var.idp_name
  inactive_user_period             = var.inactive_user_period
  inactive_user_deletion_enable    = var.inactive_user_deletion_enable
  internal_alb_dns_name            = data.terraform_remote_state.cluster.internal_alb_dns_name
  internal_alb_listener_arn        = data.terraform_remote_state.cluster.internal_alb_https_listener_arn
  invite_email_delay_seconds       = var.invite_email_delay_seconds
  invite_grace_period              = var.invite_grace_period
  invite_lifespan                  = var.invite_lifespan
  lost_security_key_email_days     = var.lost_security_key_email_days
  memory                           = var.memory
  memory_cron                      = var.memory_cron
  method_codeLength                = var.method_codeLength
  method_gracePeriod               = var.method_gracePeriod
  method_lifetime                  = var.method_lifetime
  method_maxAttempts               = var.method_maxAttempts
  mfa_allow_disable                = var.mfa_allow_disable
  mfa_lifetime                     = var.mfa_lifetime
  mfa_manager_bcc                  = var.mfa_manager_bcc
  mfa_manager_help_bcc             = var.mfa_manager_help_bcc
  mfa_required_for_new_users       = var.mfa_required_for_new_users
  mfa_totp_apibaseurl              = var.mfa_totp_apibaseurl
  mfa_totp_apikey                  = var.mfa_totp_apikey
  mfa_totp_apisecret               = var.mfa_totp_apisecret
  mfa_webauthn_apibaseurl          = var.mfa_webauthn_apibaseurl
  mfa_webauthn_apikey              = var.mfa_webauthn_apikey
  mfa_webauthn_apisecret           = var.mfa_webauthn_apisecret
  mfa_webauthn_appid               = var.mfa_webauthn_appid
  mfa_webauthn_rpdisplayname       = var.mfa_webauthn_rpdisplayname
  mfa_webauthn_rpid                = var.mfa_webauthn_rpid
  rp_origins                       = var.rp_origins
  minimum_backup_codes_before_nag  = var.minimum_backup_codes_before_nag
  mysql_host                       = data.terraform_remote_state.database.rds_address
  mysql_pass                       = data.terraform_remote_state.database.db_idbroker_pass
  mysql_user                       = var.mysql_user
  notification_email               = var.notification_email
  password_expiration_grace_period = var.password_expiration_grace_period
  password_lifespan                = var.password_lifespan
  password_mfa_lifespan_extension  = var.password_mfa_lifespan_extension
  password_profile_url             = var.password_profile_url
  password_reuse_limit             = var.password_reuse_limit
  profile_review_interval          = var.profile_review_interval
  run_task                         = var.run_task
  send_get_backup_codes_emails     = var.send_get_backup_codes_emails
  send_invite_emails               = var.send_invite_emails
  send_lost_security_key_emails    = var.send_lost_security_key_emails
  send_method_purged_emails        = var.send_method_purged_emails
  send_method_reminder_emails      = var.send_method_reminder_emails
  send_mfa_disabled_emails         = var.send_mfa_disabled_emails
  send_mfa_enabled_emails          = var.send_mfa_enabled_emails
  send_mfa_option_added_emails     = var.send_mfa_option_added_emails
  send_mfa_option_removed_emails   = var.send_mfa_option_removed_emails
  send_mfa_rate_limit_emails       = var.send_mfa_rate_limit_emails
  send_password_changed_emails     = var.send_password_changed_emails
  send_password_expired_emails     = var.send_password_expired_emails
  send_password_expiring_emails    = var.send_password_expiring_emails
  send_refresh_backup_codes_emails = var.send_refresh_backup_codes_emails
  send_welcome_emails              = var.send_welcome_emails
  ssl_policy                       = var.ssl_policy
  subdomain                        = var.broker_subdomain
  subject_for_get_backup_codes     = var.subject_for_get_backup_codes
  subject_for_invite               = var.subject_for_invite
  subject_for_lost_security_key    = var.subject_for_lost_security_key
  subject_for_method_purged        = var.subject_for_method_purged
  subject_for_method_reminder      = var.subject_for_method_reminder
  subject_for_method_verify        = var.subject_for_method_verify
  subject_for_mfa_disabled         = var.subject_for_mfa_disabled
  subject_for_mfa_enabled          = var.subject_for_mfa_enabled
  subject_for_mfa_manager          = var.subject_for_mfa_manager
  subject_for_mfa_manager_help     = var.subject_for_mfa_manager_help
  subject_for_mfa_option_added     = var.subject_for_mfa_option_added
  subject_for_mfa_option_removed   = var.subject_for_mfa_option_removed
  subject_for_mfa_rate_limit       = var.subject_for_mfa_rate_limit
  subject_for_password_changed     = var.subject_for_password_changed
  subject_for_password_expired     = var.subject_for_password_expired
  subject_for_password_expiring    = var.subject_for_password_expiring
  subject_for_refresh_backup_codes = var.subject_for_refresh_backup_codes
  subject_for_welcome              = var.subject_for_welcome
  support_email                    = var.support_email
  support_name                     = var.support_name
  vpc_id                           = data.terraform_remote_state.cluster.vpc_id
  wildcard_cert_arn                = data.terraform_remote_state.cluster.wildcard_cert_arn
}
```
