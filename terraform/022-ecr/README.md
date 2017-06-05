# 022-ecr - EC2 Container Service Image Repository
This module is used to create an ECS image repositories for all services

## What this does

 - Create ECR repositories for id-broker, pw-manager, simplesamlphp, and id-sync
 - Attache ECR policy to allow appropriate access

## Required Inputs

 - `repo_name` - Name of repo, ex: Doorman, IdP, etc.
 - `ecsServiceRole_arn` - ARN for ECS Service Role
 - `ecsInstanceRole_arn` - ARN for ECS Instance Role
 - `cd_user_arn` - ARN for an IAM user used by a Continuous Delivery service for pushing Docker images

## Outputs

 - `ecr_repo_idbroker` - The repository url for id-broker. Ex: `1234567890.dkr.ecr.us-east-1.amazonaws.com/idp-name/id-broker-environment`
 - `ecr_repo_pwapi` - The repository url for pw-api. Ex: `1234567890.dkr.ecr.us-east-1.amazonaws.com/idp-name/pw-api-environment`
 - `ecr_repo_simplesamlphp` - The repository url for simplesamlphp. Ex: `1234567890.dkr.ecr.us-east-1.amazonaws.com/idp-name/simplesamlphp-environment`
 - `ecr_repo_idsync` - The repository url for id-sync. Ex: `1234567890.dkr.ecr.us-east-1.amazonaws.com/idp-name/id-sync-environment`

## Usage Example

```hcl
module "ecr" {
  source = "github.com/silinternational/idp-in-a-box//terraform/022-ecr"
  idp_name = "${var.idp_name}"
  app_env = "${var.app_env}"
  ecsInstanceRole_arn = "${data.terraform_remote_state.core.ecsInstanceRole_arn}"
  ecsServiceRole_arn = "${data.terraform_remote_state.core.ecsServiceRole_arn}"
  cd_user_arn = "${data.terraform_remote_state.core.cduser_arn}"
}
```
