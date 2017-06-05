/*
 * id-broker
 */
module "ecr_idbroker" {
  source = "github.com/silinternational/terraform-modules//aws/ecr"
  repo_name = "${var.idp_name}/id-broker-${var.app_env}"
  ecsInstanceRole_arn = "${var.ecsInstanceRole_arn}"
  ecsServiceRole_arn = "${var.ecsServiceRole_arn}"
  cd_user_arn = "${var.cd_user_arn}"
}

/*
 * pw-api
 */
module "ecr_pwapi" {
  source = "github.com/silinternational/terraform-modules//aws/ecr"
  repo_name = "${var.idp_name}/pw-api-${var.app_env}"
  ecsInstanceRole_arn = "${var.ecsInstanceRole_arn}"
  ecsServiceRole_arn = "${var.ecsServiceRole_arn}"
  cd_user_arn = "${var.cd_user_arn}"
}

/*
 * simplesamlphp
 */
module "ecr_simplesamlphp" {
  source = "github.com/silinternational/terraform-modules//aws/ecr"
  repo_name = "${var.idp_name}/simplesamlphp-${var.app_env}"
  ecsInstanceRole_arn = "${var.ecsInstanceRole_arn}"
  ecsServiceRole_arn = "${var.ecsServiceRole_arn}"
  cd_user_arn = "${var.cd_user_arn}"
}

/*
 * id-sync
 */
module "ecr_idsync" {
  source = "github.com/silinternational/terraform-modules//aws/ecr"
  repo_name = "${var.idp_name}/id-sync-${var.app_env}"
  ecsInstanceRole_arn = "${var.ecsInstanceRole_arn}"
  ecsServiceRole_arn = "${var.ecsServiceRole_arn}"
  cd_user_arn = "${var.cd_user_arn}"
}
