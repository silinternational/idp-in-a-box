/*
 * IAM outputs
 */

output "cduser_access_key_id" {
  description = "CD user access key ID"
  value       = one(aws_iam_access_key.cduser[*].id)
}

output "cduser_access_key_secret" {
  description = "CD user access key secret"
  value       = one(aws_iam_access_key.cduser[*].secret)
  sensitive   = true
}

output "cduser_arn" {
  description = "CD user ARN"
  value       = one(aws_iam_user.cd[*].arn)
}

output "cduser_username" {
  description = "CD user name"
  value       = one(aws_iam_user.cd[*].name)
}

/*
 * ECS cluster outputs
 */
output "ecs_ami_id" {
  value = module.ecscluster.ami_id
}

output "ecs_cluster_id" {
  value = module.ecscluster.ecs_cluster_id
}

output "ecs_cluster_name" {
  value = module.ecscluster.ecs_cluster_name
}

output "ecs_instance_profile_id" {
  value = module.ecscluster.ecs_instance_profile_id
}

output "ecsInstanceRole_arn" {
  value = module.ecscluster.ecsInstanceRole_arn
}

output "ecsServiceRole_arn" {
  value = module.ecscluster.ecsServiceRole_arn
}


/*
 * AppConfig outputs
 */
output "appconfig_app_id" {
  description = "AppConfig application ID"
  value       = one(aws_appconfig_application.this[*].id)
}

output "appconfig_env_id" {
  description = "AppConfig environment ID"
  value       = one(aws_appconfig_environment.this[*].environment_id)
}
