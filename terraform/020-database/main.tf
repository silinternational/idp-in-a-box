/*
 * Create RDS instance
 * root user username and password are displayed in output
 */
resource "random_id" "db_root_pass" {
  byte_length = 16
}

module "rds" {
  source                  = "github.com/silinternational/terraform-modules//aws/rds/mariadb?ref=8.0.0"
  app_name                = var.app_name
  app_env                 = var.app_env
  db_name                 = var.db_name
  db_root_user            = var.mysql_user
  db_root_pass            = random_id.db_root_pass.hex
  subnet_group_name       = var.subnet_group_name
  availability_zone       = var.availability_zone
  security_groups         = var.security_groups
  engine                  = var.engine
  engine_version          = var.engine_version
  allocated_storage       = var.allocated_storage
  instance_class          = var.instance_class
  storage_type            = var.storage_type
  backup_retention_period = var.backup_retention_period
  multi_az                = var.multi_az
  skip_final_snapshot     = var.skip_final_snapshot
}

/*
 * Generate db passwords for different apps
 * Value is displayed in output to use to externally create user
 */
resource "random_id" "db_idbroker_pass" {
  byte_length = 16
}

resource "random_id" "db_emailservice_pass" {
  byte_length = 16
}

resource "random_id" "db_pwmanager_pass" {
  byte_length = 16
}

resource "random_id" "db_ssp_pass" {
  byte_length = 16
}

locals {
  db_users_sql = templatefile("${path.module}/db-users.sql", {
    pwmanager_pass    = random_id.db_pwmanager_pass.hex
    idbroker_pass     = random_id.db_idbroker_pass.hex
    ssp_pass          = random_id.db_ssp_pass.hex
    emailservice_pass = random_id.db_emailservice_pass.hex
    }
  )
}

