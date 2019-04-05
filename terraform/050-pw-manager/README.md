# 050-pw-manager - ECS service for password manager API and S3 config for UI
This module is used to create an ECS service running the password manager API and static site hosting for the UI.

## What this does

 - Create ALB target group for API with hostname based routing
 - Create task definition and ECS service for password manager API service
 - Create S3 bucket for UI
 - Create CloudFront distribution to provide SSL support for UI
 - Create Cloudflare DNS records for API and UI

## Required Inputs

 - `alb_dns_name` - DNS name for application load balancer
 - `alb_https_listener_arn` - ARN for ALB HTTPS listener
 - `alerts_email` - Email address to send alerts/notifications to
 - `api_subdomain` - Subdomain for pw manager api
 - `app_env` - Application environment
 - `app_name` - Application name
 - `auth_saml_checkResponseSigning`  - true/false whether to check response for signature. Default: `true`
 - `auth_saml_entityId` - Entity ID for this SP
 - `auth_saml_idpCertificate` - Public cert contents for IdP 
 - `auth_saml_requireEncryptedAssertion` - true/false whether to require assertion to be encrypted. Default: `true`
 - `auth_saml_signRequest` - true/false whether to sign auth requests. Default: `true`
 - `auth_saml_sloUrl` - SLO url for IdP
 - `auth_saml_spCertificate` - Public cert contents for this SP
 - `auth_saml_spPrivateKey` - Private cert contents for this SP
 - `auth_saml_ssoUrl` - SSO url for IdP
 - `cloudflare_domain` - Top level domain name for use with Cloudflare
 - `cpu` - Amount of CPU to allocate to API container
 - `db_name` - Name of MySQL database for pw-api
 - `desired_count` - Number of API tasks that should be run
 - `docker_image` - URL to Docker image
 - `ecs_cluster_id` - ID for ECS Cluster
 - `ecsServiceRole_arn` - ARN for ECS Service Role
 - `email_service_accessToken` - Access Token for Email Service API
 - `email_service_assertValidIp` - Whether or not to assert IP address for Email Service API is trusted. Default: `true`
 - `email_service_baseUrl` - Base URL to Email Service API
 - `email_service_validIpRanges` - List of valid IP ranges to Email Service API
 - `from_name` - Email from name
 - `id_broker_access_token` - Access token for calling id-broker
 - `id_broker_assertValidBrokerIp` - Whether or not to assert IP address for ID Broker API is trusted. Default: `true`
 - `id_broker_base_uri` - Base URL to id-broker API
 - `id_broker_validIpRanges` - List of valid IP blocks for ID Broker
 - `idp_name` - Short name of IdP for use in logs and email alerts
 - `logentries_set_id` - Logentries logset ID for creating new log in
 - `memory` - Amount of memory to allocate to API container
 - `mysql_host` - Address for RDS instance
 - `mysql_pass` - MySQL password for id-broker
 - `mysql_user` - MySQL username for id-broker
 - `recaptcha_key` - Recaptcha site key
 - `recaptcha_secret` - Recaptcha secret
 - `support_email` - Email address for end user support
 - `ui_subdomain` - Subdomain for PW UI
 - `vpc_id` - ID for VPC
 - `wildcard_cert_arn` - ARN to ACM wildcard cert

## Optional Inputs

 - `code_length` - Number of digits in reset code. Default: `6`
 - `password_rule_enablehibp` - Enable haveibeenpwned.com password check. Default: `true`
 - `password_rule_maxlength` - Maximum password length. Default: `255`
 - `password_rule_minlength` - Minimum password length. Default: `10`
 - `password_rule_minscore` - Minimum password score. Default: `3`
 - `support_feedback` - Email address for end user feedback, displayed on PW UI.
 - `support_phone` - Phone number for end user support, displayed on PW UI.
 - `support_url` - URL for end user support, displayed on PW UI.

## Outputs

 - `ui_bucket` - ARN for S3 bucket for UI
 - `cloudfront_distribution_id` - Cloudfront distribution ID
 - `ui_hostname` - Full hostname for UI
 - `api_hostname` - Full hostname for API
 - `db_pwmanager_user` - Username for mysql

## Usage Example

```hcl
module "pwmanager" {
  alb_dns_name                        = "${data.terraform_remote_state.cluster.alb_dns_name}"
  alb_https_listener_arn              = "${data.terraform_remote_state.cluster.alb_https_listener_arn}"
  alerts_email                        = "${var.alerts_email}"
  api_subdomain                       = "${var.api_subdomain}"
  app_env                             = "${var.app_env}"
  app_name                            = "${var.app_name}"
  auth_saml_checkResponseSigning      = "${var.auth_saml_checkResponseSigning}"
  auth_saml_entityId                  = "${var.auth_saml_entityId}"
  auth_saml_idpCertificate            = "${var.auth_saml_idpCertificate}"
  auth_saml_requireEncryptedAssertion = "${var.auth_saml_requireEncryptedAssertion}"
  auth_saml_signRequest               = "${var.auth_saml_signRequest}"
  auth_saml_sloUrl                    = "${var.auth_saml_sloUrl}"
  auth_saml_spCertificate             = "${var.auth_saml_spCertificate}"
  auth_saml_spPrivateKey              = "${var.auth_saml_spPrivateKey}"
  auth_saml_ssoUrl                    = "${var.auth_saml_ssoUrl}"
  cd_user_username                    = "${data.terraform_remote_state.core.cduser_username}"
  cloudflare_domain                   = "${var.cloudflare_domain}"
  code_length                         = "${var.code_length}"
  cpu                                 = "${var.cpu}"
  db_name                             = "${var.db_name}"
  desired_count                       = "${var.desired_count}"
  docker_image                        = "${data.terraform_remote_state.ecr.ecr_repo_pwapi}"
  ecs_cluster_id                      = "${data.terraform_remote_state.core.ecs_cluster_id}"
  ecsServiceRole_arn                  = "${data.terraform_remote_state.core.ecsServiceRole_arn}"
  email_service_accessToken           = "${data.terraform_remote_state.email.access_token_pwmanager}"
  email_service_assertValidIp         = "${var.email_service_assertValidIp}"
  email_service_baseUrl               = "https://${data.terraform_remote_state.email.hostname}"
  email_service_validIpRanges         = ["${data.terraform_remote_state.cluster.private_subnet_cidr_blocks}"]
  from_name                           = "${var.from_name}"
  id_broker_access_token              = "${data.terraform_remote_state.broker.access_token_pwmanager}"
  id_broker_assertValidBrokerIp       = "${var.id_broker_assertValidBrokerIp}"
  id_broker_base_uri                  = "https://${data.terraform_remote_state.broker.hostname}"
  id_broker_validIpRanges             = ["${data.terraform_remote_state.cluster.private_subnet_cidr_blocks}"]
  idp_display_name                    = "${var.idp_display_name}"
  idp_name                            = "${var.idp_name}"
  logentries_set_id                   = "${data.terraform_remote_state.cluster.logentries_set_id}"
  memory                              = "${var.memory}"
  mysql_host                          = "${data.terraform_remote_state.database.rds_address}"
  mysql_pass                          = "${data.terraform_remote_state.database.db_pwmanager_pass}"
  mysql_user                          = "${var.mysql_user}"
  password_rule_enablehibp            = "${var.password_rule_enablehibp}"
  password_rule_maxlength             = "${var.password_rule_maxlength}"
  password_rule_minlength             = "${var.password_rule_minlength}"
  password_rule_minscore              = "${var.password_rule_minscore}"
  recaptcha_key                       = "${var.recaptcha_key}"
  recaptcha_secret                    = "${var.recaptcha_secret}"
  source                              = "github.com/silinternational/idp-in-a-box//terraform/050-pw-manager?ref=develop-4.0"
  support_email                       = "${var.support_email}"
  support_feedback                    = "${var.support_feedback}"
  support_phone                       = "${var.support_phone}"
  support_url                         = "${var.support_url}"
  ui_subdomain                        = "${var.ui_subdomain}"
  vpc_id                              = "${data.terraform_remote_state.cluster.vpc_id}"
  wildcard_cert_arn                   = "${data.terraform_remote_state.cluster.cloudfront_distribution_cert_arn}"
}
```
