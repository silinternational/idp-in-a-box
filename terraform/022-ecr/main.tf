/*
 * id-broker
 */
module "ecr_idbroker" {
  source              = "github.com/silinternational/terraform-modules//aws/ecr?ref=3.5.0"
  repo_name           = "${var.idp_name}/id-broker"
  ecsInstanceRole_arn = var.ecsInstanceRole_arn
  ecsServiceRole_arn  = var.ecsServiceRole_arn
  cd_user_arn         = var.cd_user_arn
}

/*
 * email-service
 */
module "ecr_emailservice" {
  source              = "github.com/silinternational/terraform-modules//aws/ecr?ref=3.5.0"
  repo_name           = "${var.idp_name}/email-service"
  ecsInstanceRole_arn = var.ecsInstanceRole_arn
  ecsServiceRole_arn  = var.ecsServiceRole_arn
  cd_user_arn         = var.cd_user_arn
}

/*
 * pw-api
 */
module "ecr_pwapi" {
  source              = "github.com/silinternational/terraform-modules//aws/ecr?ref=3.5.0"
  repo_name           = "${var.idp_name}/pw-api"
  ecsInstanceRole_arn = var.ecsInstanceRole_arn
  ecsServiceRole_arn  = var.ecsServiceRole_arn
  cd_user_arn         = var.cd_user_arn
}

/*
 * simplesamlphp
 */
module "ecr_simplesamlphp" {
  source              = "github.com/silinternational/terraform-modules//aws/ecr?ref=3.5.0"
  repo_name           = "${var.idp_name}/simplesamlphp"
  ecsInstanceRole_arn = var.ecsInstanceRole_arn
  ecsServiceRole_arn  = var.ecsServiceRole_arn
  cd_user_arn         = var.cd_user_arn
}

/*
 * id-sync
 */
module "ecr_idsync" {
  source              = "github.com/silinternational/terraform-modules//aws/ecr?ref=3.5.0"
  repo_name           = "${var.idp_name}/id-sync"
  ecsInstanceRole_arn = var.ecsInstanceRole_arn
  ecsServiceRole_arn  = var.ecsServiceRole_arn
  cd_user_arn         = var.cd_user_arn
}

/*
 * db-backup
 */
module "ecr_dbbackup" {
  source              = "github.com/silinternational/terraform-modules//aws/ecr?ref=3.5.0"
  repo_name           = "${var.idp_name}/db-backup"
  ecsInstanceRole_arn = var.ecsInstanceRole_arn
  ecsServiceRole_arn  = var.ecsServiceRole_arn
  cd_user_arn         = var.cd_user_arn
}

