# 041-id-broker-search-lambda - Lambda function for calling id-broker search api
This module is used to create a lambda function for calling id-broker's search api

## What this does

 - Create a lambda function

## Required Inputs

 - `app_env` - Application environment
 - `broker_base_url` - Base URL to ID Broker service
 - `broker_token` - Authentication token for ID Broker API
 - `idp_name` - IdP Name
 - `remote_role_arn` - ARN to IAM Role the lambda function should assume
 - `security_group_ids` - List of security groups to place function in
 - `subnet_ids` - List of subnet ids to place function in
 - `function_bucket_name` - Bucket name containing lambda function zip
 
## Optional Inputs

 - `app_name` - Default: `idp-id-broker-search`
 - `function_name` - Default: `idp-id-broker-search`
 - `lambda_runtime` - AWS Lambda runtime environment, either `provided.al2` or `go1.x`. `go1.x` is deprecated but remains the default for backward compatibility
 - `memory_size` - Default: `128`
 - `timeout` - Default: `5`
 - `function_zip_name` - Key to file in S3 for function zip file, Default: `idp-id-broker-search.zip`

## Outputs

 - `function_arn` - ARN for function

## Usage Example

```hcl
module "brokersearch" {
  source               = "github.com/silinternational/idp-in-a-box//terraform/041-id-broker-search-lambda"
  app_env              = var.app_env
  broker_base_url      = "https://${data.terraform_remote_state.broker.hostname}"
  broker_token         = data.terraform_remote_state.broker.access_token_search
  idp_name             = var.idp_name
  remote_role_arn      = var.role_arn
  security_group_ids   = [data.terraform_remote_state.cluster.vpc_default_sg_id]
  subnet_ids           = data.terraform_remote_state.cluster.private_subnet_ids
  function_bucket_name = "idp-id-broker-search-${var.aws_region}"
  function_zip_name    = "${var.function_release_version}/${var.function_zip_name}"
}
```
