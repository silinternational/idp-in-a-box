# 032-db-backup - Database backup service
This module is used to run mysqldump and backup files to S3

## What this does

 - Create an S3 bucket to store backups
 - Create a AWS backup user for script to use
 - Create task definition and ECS service for db-backup

## Required Inputs

 - `app_env` - Application environment
 - `docker_image` - The docker image to use for this
 - `ecs_cluster_id` - ID for ECS Cluster
 - `ecsServiceRole_arn` - ARN for ECS Service Role
 - `idp_name` - Short name of IdP for use in logs and email alerts
 - `logentries_set_id` - Logentries logset ID for creating new log in
 - `mysql_host` - Address for RDS instance
 - `mysql_pass` - MySQL password
 - `mysql_user` - MySQL username
 - `vpc_id` - ID for VPC

## Optional Inputs

 - `app_name` - Application name
 - `cpu` - CPU resources to allot to each task instance
 - `cron_schedule` - Schedule for CRON execution. Default: `0 2 * * *`
 - `db_names` - List of database names to backup. Default: `["emailservice", "idbroker", "pwmanager", "ssp"]`
 - `memory` - Memory (RAM) resources to allot to each task instance
 - `service_mode` - Either `backup` or `restore`. Default: `backup`

## Outputs

 - `cron_schedule` - Schedule for CRON execution
 - `s3_bucket_name` - S3 Bucket name
 - `s3_bucket_arn` - S3 Bucket ARN

## Usage Example

```hcl
module "dbbackup" {
  source                    = "github.com/silinternational/idp-in-a-box//terraform/032-db-backup"
  app_env                   = "${var.app_env}"
  app_name                  = "${var.app_name}"
  cpu                       = "${var.cpu}"
  db_names                  = ["${var.db_names}"]
  docker_image              = "${data.terraform_remote_state.ecr.ecr_repo_dbbackup}"
  ecs_cluster_id            = "${data.terraform_remote_state.core.ecs_cluster_id}"
  ecsServiceRole_arn        = "${data.terraform_remote_state.core.ecsServiceRole_arn}"
  idp_name                  = "${var.idp_name}"
  logentries_set_id         = "${data.terraform_remote_state.cluster.logentries_set_id}"
  memory                    = "${var.memory}"
  mysql_host                = "${data.terraform_remote_state.database.rds_address}"
  mysql_pass                = "${data.terraform_remote_state.database.mysql_pass}"
  mysql_user                = "${data.terraform_remote_state.database.mysql_user}"
  service_mode              = "${var.service_mode}"
  vpc_id                    = "${data.terraform_remote_state.cluster.vpc_id}"
}
```
