module "backup" {
  source = "../terraform/032-db-backup"

  app_env                          = ""
  app_name                         = ""
  backup_user_name                 = ""
  cloudwatch_log_group_name        = ""
  cpu                              = ""
  event_schedule                   = ""
  db_names                         = [""]
  docker_image                     = ""
  ecs_cluster_id                   = ""
  idp_name                         = ""
  memory                           = ""
  mysql_host                       = ""
  mysql_pass                       = ""
  mysql_user                       = ""
  service_mode                     = ""
  enable_aws_backup                = true
  aws_backup_schedule              = ""
  aws_backup_notification_events   = [""]
  backup_sns_email                 = ""
  delete_recovery_point_after_days = 7
  enable_s3_to_b2_sync             = false
  b2_application_key_id            = ""
  b2_application_key               = ""
  b2_bucket                        = ""
  rclone_arguments                 = "--transfers 4 --checkers 8"
  b2_path                          = ""
  sync_schedule                    = null
}
