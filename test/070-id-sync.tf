module "sync" {
  source = "../terraform/070-id-sync"

  alerts_email                 = ""
  allow_empty_email            = ""
  app_env                      = ""
  app_name                     = ""
  aws_region                   = ""
  cloudwatch_log_group_name    = ""
  cpu                          = ""
  docker_image                 = ""
  ecs_cluster_id               = ""
  email_service_accessToken    = ""
  email_service_assertValidIp  = ""
  email_service_baseUrl        = ""
  email_service_validIpRanges  = [""]
  enable_new_user_notification = ""
  enable_sync                  = ""
  id_broker_access_token       = ""
  id_broker_adapter            = ""
  id_broker_assertValidIp      = ""
  id_broker_base_url           = ""
  id_broker_trustedIpRanges    = [""]
  id_store_adapter             = ""
  id_store_config              = { a = "b" }
  idp_display_name             = ""
  idp_name                     = ""
  memory                       = ""
  notifier_email_to            = ""
  sync_safety_cutoff           = ""
  vpc_id                       = ""
}
