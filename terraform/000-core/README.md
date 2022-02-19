# 000-core - Core setup: IAM users, ECS cluster
This module is used to create an ECS cluster along with the necessary
IAM roles to function. It can also optionally create an ACM certificate
used by later workspaces for HTTPS with the ALB.

## What this does

 - Create ECS cluster named after `app_name` and `app_env`
 - Create IAM roles and policies for ECS services and instances
 - Optionally create and validate an ACM certificate using DNS

## Required Inputs

 - `app_name` - Name of application, ex: Doorman, IdP, etc.
 - `app_env` - Name of environment, ex: prod, test, etc.
 - `cert_domain` - The TLD for the certificate domain.

## Optional Inputs

 - `aws_region` - Region to deploy in, ex: `us-east-1`
 - `create_acm_cert` - Bool of whether or not to create an ACM cert. Default: `false`

## Outputs

 - `cduser_access_key_id` - AWS access key id for continuous delivery user
 - `cduser_access_key_secret` - AWS access key secret for continuous delivery user
 - `cduser_arn` - ARN for continuous delivery IAM user
 - `cduser_username` - Username for contiuous delivery IAM user
 - `ecs_cluster_name` - The ECS cluster name
 - `ecs_instance_profile_id` - The ID for created IAM profile `ecsInstanceProfile`
 - `ecsInstanceRole_arn` - The ARN for created IAM role `ecsInstanceRole`
 - `ecsServiceRole_arn` - The ID for created IAM role `ecsServiceRole`


## Usage Example

```hcl
module "core" {
  source           = "github.com/silinternational/idp-in-a-box//terraform/000-core"
  app_name         = var.app_name
  app_env          = var.app_env
  cert_domain      = var.cert_domain
  create_acm_cert  = var.create_acm_cert
}
```
