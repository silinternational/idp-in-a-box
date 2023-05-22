/*
 * Create RDS instance
 * root user username and password are displayed in output
 */
resource "random_id" "db_root_pass" {
  count       = var.create_passwords ? 1 : 0
  byte_length = 16
}

module "rds" {
  source                  = "github.com/silinternational/terraform-modules//aws/rds/mariadb?ref=develop"
  app_name                = var.app_name
  app_env                 = var.app_env
  db_name                 = var.db_name
  db_root_user            = var.mysql_user
  db_root_pass            = one(random_id.db_root_pass[*].hex)
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
  replicate_source_db     = var.replicate_source_db
}

/*
 * Generate db passwords for different apps
 * Value is displayed in output to use to externally create user
 */
resource "random_id" "db_idbroker_pass" {
  count       = var.create_passwords ? 1 : 0
  byte_length = 16
}

resource "random_id" "db_emailservice_pass" {
  count       = var.create_passwords ? 1 : 0
  byte_length = 16
}

resource "random_id" "db_pwmanager_pass" {
  count       = var.create_passwords ? 1 : 0
  byte_length = 16
}

resource "random_id" "db_ssp_pass" {
  count       = var.create_passwords ? 1 : 0
  byte_length = 16
}

locals {
  pwmanager_pass    = one(random_id.db_pwmanager_pass[*].hex)
  idbroker_pass     = one(random_id.db_idbroker_pass[*].hex)
  ssp_pass          = one(random_id.db_ssp_pass[*].hex)
  emailservice_pass = one(random_id.db_emailservice_pass[*].hex)

  db_users_sql = var.create_passwords ? templatefile("${path.module}/db-users.sql", {
    pwmanager_pass    = local.pwmanager_pass
    idbroker_pass     = local.idbroker_pass
    ssp_pass          = local.ssp_pass
    emailservice_pass = local.emailservice_pass
    }
  ) : ""
}
