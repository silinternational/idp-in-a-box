module "backup" {
  source = "../terraform/032-db-backup"

  app_env                   = ""
  app_name                  = ""
  backup_user_name          = ""
  cloudwatch_log_group_name = ""
  cpu                       = ""
  cron_schedule             = ""
  db_names                  = [""]
  docker_image              = ""
  ecsServiceRole_arn        = ""
  ecs_cluster_id            = ""
  idp_name                  = ""
  memory                    = ""
  mysql_host                = ""
  mysql_pass                = ""
  mysql_user                = ""
  service_mode              = ""
  vpc_id                    = ""
}
