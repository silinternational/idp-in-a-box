# 030-phpmyadmin - ECS service for phpmyadmin for simple GUI into database
This module is used to create an ECS service running phpmyadmin. It is used temporarily for db and account creation
for individual services

## What this does

 - Create target group for ALB to route based on hostname
 - Create task definition and ECS service for phpmyadmin
 - Create Cloudflare DNS record

## Required Inputs

 - `app_name` - Application name
 - `app_env` - Application environment
 - `vpc_id` - ID for VPC
 - `alb_https_listener_arn` - ARN to ALB listener for HTTPS traffic
 - `subdomain` - Subdomain for phpmyadmin
 - `cloudflare_domain` - Top level domain name for use with Cloudflare
 - `rds_address` - Address for RDS instance
 - `ecs_cluster_id` - ID for ECS Cluster
 - `ecsServiceRole_arn` - ARN for ECS Service Role
 - `alb_dns_name` - DNS name for application load balancer

## Outputs

 - `phpmyadmin_url` - The url to phpmyadmin, built on `pma_subdomain` and `cloudflare_domain`

## Usage Example

```hcl
module "phpmyadmin" {
  source = "github.com/silinternational/idp-in-a-box//terraform/030-phpmyadmin"
  app_name = "${var.app_name}"
  app_env = "${var.app_env}"
  vpc_id = "${data.terraform_remote_state.cluster.vpc_id}"
  alb_https_listener_arn = "${data.terraform_remote_state.cluster.alb_https_listener_arn}"
  subdomain = "${var.pma_subdomain}"
  cloudflare_domain = "${var.cloudflare_domain}"
  rds_address = "${data.terraform_remote_state.database.rds_address}"
  ecs_cluster_id = "${data.terraform_remote_state.core.ecs_cluster_id}"
  ecsServiceRole_arn = "${data.terraform_remote_state.core.ecsServiceRole_arn}"
  alb_dns_name = "${data.terraform_remote_state.cluster.alb_dns_name}"
}
```
