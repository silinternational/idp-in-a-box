# 020-database - Create database and users needed for all services

## What this does

 - Create RDS instance named after `db_name`
 - Generate random passwords for db users

## Required Inputs

 - `app_name` - Name of application, ex: Doorman, IdP, etc.
 - `app_env` - Name of environment, ex: production, testing, etc.
 - `db_name` - Name of database to be created by default
 - `mysql_user` - Root database username
 - `subnet_group_name` - Name of DB subnet group to place instance in
 - `availability_zone` - Availability zone name to place instance in
 - `security_groups` - List of security group ids to assign instance to

### Optional Inputs

 - `engine` - Default: `mariadb`
 - `engine_version` - Default: `<empty>`
 - `allocated_storage` - Default: `8`G
 - `storage_type` - Default: `gp2`
 - `instance_class` - Default: `db.t2.micro`
 - `backup_retention_period` - Default: `14` days
 - `multi_az` - Default: `false`

## Outputs

 - `rds_arn` - ARN of RDS instance ID
 - `rds_address` - Address for RDS instance
 - `mysql_user` - Username for root DB user
 - `mysql_pass` - Password for root DB user
 - `db_idbroker_pass` - Password for `idbroker` user
 - `db_pwmanager_pass` - Password for `pwmanager` user
 - `db_ssp_pass` - Password for `ssp` user

## Example Usage

```hcl
module "database" {
  source            = "github.com/silinternational/idp-in-a-box//terraform/020-database"
  app_name          = "${var.app_name}"
  app_env           = "${var.app_env}"
  db_name           = "${var.db_name}"
  mysql_user        = "${var.mysql_user}"
  subnet_group_name = "${data.terraform_remote_state.cluster.db_subnet_group_name}"
  availability_zone = "${data.terraform_remote_state.cluster.aws_zones[0]}"
  security_groups   = ["${data.terraform_remote_state.cluster.vpc_default_sg_id}"]
}
```
