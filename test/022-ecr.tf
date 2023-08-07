module "ecr" {
  source = "../terraform/022-ecr"

  app_env             = ""
  cd_user_arn         = ""
  ecsInstanceRole_arn = ""
  ecsServiceRole_arn  = ""
  idp_name            = ""
}
