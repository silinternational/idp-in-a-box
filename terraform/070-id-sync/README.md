# 070-id-sync - ECS service for id-sync
This module is used to create an ECS service running the id-sync component which syncs identities from a personnel
store.

## What this does

 - Create Logentries Log
 - Create ALB target group for SSP with hostname based routing
 - Create task definition and ECS service
 - Create Cloudflare DNS record

## Required Inputs

 - `app_name` - Application name
 - `app_env` - Application environment
 - `logentries_set_id` - Logentries logset ID for creating new log in
 - `vpc_id` - ID for VPC
 - `alb_https_listener_arn` - ARN for ALB HTTPS listener
 - `subdomain` - Subdomain for SSP IdP
 - `cloudflare_domain` - Top level domain name for use with Cloudflare
 - `docker_image` - URL to Docker image
 - `email_service_accessToken` - Access token for Email Service API
 - `email_service_baseUrl` - Base URL (e.g. 'https://email.example.com') to Email Service API
 - `email_service_validIpRanges` - List of valid IP address ranges for Email Service API
 - `id_broker_access_token` - Access token for calling id-broker
 - `id_broker_adapter` - Which ID Sync adapter to use
 - `id_broker_base_url` - Base URL to id-broker API
 - `id_broker_trustedIpRanges` - List of valid IP address ranges for ID Broker API
 - `id_store_adapter` - Which ID Store adapter to use
 - `id_store_config` - A map of configuration data to pass into id-sync as env vars
 - `idp_name` - Short name of IdP for use in logs and email alerts
 - `idp_display_name` - Friendly name for IdP
 - `ecs_cluster_id` - ID for ECS Cluster
 - `ecsServiceRole_arn` - ARN for ECS Service Role
 - `alb_dns_name` - DNS name for application load balancer
 - `memory` - Amount of memory to allocate to container
 - `cpu` - Amount of CPU to allocate to container

## Optional Inputs

- `email_service_assertValidIp` - Whether or not to assert IP address for Email Service API is trusted
- `id_broker_assertValidIp` - Whether or not to assert IP address for ID Broker API is trusted
- `notifier_email_to` - Who to send notifications to about sync problems (e.g. users lacking email addresses)
- `sync_safety_cutoff` - The percentage of records allowed to be changed during a sync, provided as a float, ex: `0.2` for `20%`

## Outputs

 - `idsync_url` - URL for ID Sync webhook endpoint
 - `access_token_external` - Access token for external systems to use to make webhook calls to Sync

## Usage Example

```hcl
module "idsync" {
  source                      = "github.com/silinternational/idp-in-a-box//terraform/070-id-sync"
  memory                      = "${var.memory}"
  cpu                         = "${var.cpu}"
  app_name                    = "${var.app_name}"
  app_env                     = "${var.app_env}"
  logentries_set_id           = "${data.terraform_remote_state.cluster.logentries_set_id}"
  vpc_id                      = "${data.terraform_remote_state.cluster.vpc_id}"
  alb_https_listener_arn      = "${data.terraform_remote_state.cluster.alb_https_listener_arn}"
  subdomain                   = "${var.sync_subdomain}"
  cloudflare_domain           = "${var.cloudflare_domain}"
  docker_image                = "${data.terraform_remote_state.ecr.ecr_repo_idsync}"
  email_service_accessToken   = "${data.terraform_remote_state.email.access_token_idsync}"
  email_service_assertValidIp = "${var.email_service_assertValidIp}"
  email_service_baseUrl       = "https://${data.terraform_remote_state.email.hostname}"
  email_service_validIpRanges = ["${data.terraform_remote_state.cluster.private_subnet_cidr_blocks}"]
  id_broker_access_token      = "${data.terraform_remote_state.broker.access_token_idsync}"
  id_broker_adapter           = "${var.id_broker_adapter}"
  id_broker_assertValidIp     = "${var.id_broker_assertValidIp}"
  id_broker_base_url          = "https://${data.terraform_remote_state.broker.hostname}"
  id_broker_trustedIpRanges   = ["${data.terraform_remote_state.cluster.private_subnet_cidr_blocks}"]
  id_store_adapter            = "${var.id_store_adapter}"
  id_store_config             = "${var.id_store_config}"
  idp_name                    = "${var.idp_name}"
  idp_display_name            = "${var.idp_display_name}"
  ecs_cluster_id              = "${data.terraform_remote_state.core.ecs_cluster_id}"
  ecsServiceRole_arn          = "${data.terraform_remote_state.core.ecsServiceRole_arn}"
  alb_dns_name                = "${data.terraform_remote_state.cluster.alb_dns_name}"
  notifier_email_to           = "${var.notifier_email_to}"
}
```
