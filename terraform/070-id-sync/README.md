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
 - `id_broker_access_token` - Access token for calling id-broker
 - `id_broker_adapter` - Which ID Sync adapter to use
 - `id_broker_base_url` - Base URL to id-broker API
 - `id_store_adapter` - Which ID Store adapter to use
 - `id_store_config` - A map of configuration data to pass into id-sync as env vars
 - `idp_name` - Short name of IdP for use in logs and email alerts
 - `ecs_cluster_id` - ID for ECS Cluster
 - `ecsServiceRole_arn` - ARN for ECS Service Role
 - `alb_dns_name` - DNS name for application load balancer
 - `mailer_host` - SMTP hostname
 - `mailer_username` - SMTP username
 - `mailer_password` - SMTP password
 - `notifier_email_to` - Who to send notifications to about sync problems
 - `memory` - Amount of memory to allocate to container
 - `cpu` - Amount of CPU to allocate to container

## Outputs

 - `idsync_url` - URL for ID Sync webhook endpoint
 - `access_token_external` - Access token for external systems to use to make webhook calls to Sync

## Usage Example

```hcl
module "idsync" {
  source                 = "github.com/silinternational/idp-in-a-box//terraform/070-id-sync"
  memory                 = "${var.memory}"
  cpu                    = "${var.cpu}"
  app_name               = "${var.app_name}"
  app_env                = "${var.app_env}"
  logentries_set_id      = "${data.terraform_remote_state.cluster.logentries_set_id}"
  vpc_id                 = "${data.terraform_remote_state.cluster.vpc_id}"
  alb_https_listener_arn = "${data.terraform_remote_state.cluster.alb_https_listener_arn}"
  subdomain              = "${var.ssp_subdomain}"
  cloudflare_domain      = "${var.cloudflare_domain}"
  docker_image           = "${data.terraform_remote_state.ecr.ecr_repo_idsync}"
  id_broker_access_token = "${data.terraform_remote_state.broker.access_token_idsync}"
  id_broker_adapter      = "${var.id_broker_adapter}"
  id_broker_base_url     = "https://${data.terraform_remote_state.broker.hostname}"
  id_store_adapter       = "${var.id_store_adapter}"
  id_store_config        = "${var.id_store_config}"
  idp_name               = "${var.idp_name}"
  ecs_cluster_id         = "${data.terraform_remote_state.core.ecs_cluster_id}"
  ecsServiceRole_arn     = "${data.terraform_remote_state.core.ecsServiceRole_arn}"
  alb_dns_name           = "${data.terraform_remote_state.cluster.alb_dns_name}"
  mailer_host            = "${var.mailer_host}"
  mailer_username        = "${var.mailer_username}"
  mailer_password        = "${var.mailer_password}"
  notifier_email_to      = "${var.notifier_email_to}"
}
```
