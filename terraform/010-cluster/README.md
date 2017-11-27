# 010-cluster - Cluster setup
This module is used to setup the cluster with VPC, security groups, auto-scaling group,
ssl certificate, core application load balancer, and a Logentries log set

## What this does

 - Create VPC named after `app_name` and `app_env`
 - Create security group to allow traffic from Cloudflare IPs
 - Create auto scaling group of defined size and distribute instances across `aws_zones`
 - Locate ACM certificate for use in ALB listeners
 - Create application load balancer (ALB)
 - Create Logentries logset

## Required Inputs

 - `app_name` - Name of application, ex: Doorman, IdP, etc.
 - `app_env` - Name of environment, ex: prod, test, etc.
 - `aws_instance` - A map containing keys for `instance_type`, `volume_size`, `instance_count`
 - `aws_region` - A string with region to deploy in, example: `us-east-1`
 - `aws_zones` - A list of availability zones to distribute instances across, example: `["us-east-1a", "us-east-1b", "us-east-1c"]`
 - `cert_domain_name` - Domain name for certificate, example: `*.mydomain.com`
 - `ecs_ami_id` - ID for AMI to be used.
 - `ecs_cluster_name` - ECS cluster name for registering instances
 - `ecs_instance_profile_id` - IAM profile ID for ecsInstanceProfile


## Outputs

 - `aws_zones` - The list of zones deployed in
 - `cloudflare_sg_id` - Security group ID for Cloudflare HTTPS access
 - `db_subnet_group_name` - Database subnet group name
 - `nat_gateway_ip` - NAT gateway elastic IP address
 - `private_subnet_ids` - List of private subnet ids in VPC
 - `private_subnet_cidr_blocks` - A list of private subnet CIDR blocks, ex: `["10.0.11.0/24","10.0.22.0/24"]`
 - `public_subnet_ids` - List of public subnet ids in VPC
 - `public_subnet_cidr_blocks` - A list of public subnet CIDR blocks, ex: `["10.0.10.0/24","10.0.12.0/24"]`
 - `vpc_default_sg_id` - The default security group ID for the VPC
 - `vpc_id` - ID for the VPC
 - `alb_arn` - ARN for application load balancer
 - `alb_default_tg_arn` - ARN for default target group on load balancer
 - `alb_dns_name` - DNS name for ALB
 - `alb_https_listener_arn` - ARN for HTTPS listener on ALB
 - `alb_id` - ID for ALB
 - `wildcard_cert_arn` - ARN to wildcard ACM certificate
 - `logentries_set_id` - ID to Logentries Logset

## Example Usage

```hcl
module "cluster" {
  source                  = "github.com/silinternational/idp-in-a-box//terraform/010-cluster"
  app_name                = "${var.app_name}"
  app_env                 = "${var.app_env}"
  aws_instance            = "${var.aws_instance}"
  aws_region              = "${var.aws_region}"
  aws_zones               = ["${var.aws_zones}"]
  cert_domain_name        = "${var.cert_domain_name}"
  ecs_ami_id              = "${data.terraform_remote_state.core.ecs_ami_id}"
  ecs_cluster_name        = "${data.terraform_remote_state.core.ecs_cluster_name}"
  ecs_instance_profile_id = "${data.terraform_remote_state.core.ecs_instance_profile_id}"
}
```
