module "email" {
  source = "../terraform/031-email-service"

  app_env                   = ""
  app_name                  = ""
  cloudflare_domain         = ""
  cloudwatch_log_group_name = ""
  cpu_api                   = ""
  cpu_cron                  = ""
  db_name                   = ""
  desired_count_api         = ""
  docker_image              = ""
  ecsServiceRole_arn        = ""
  ecs_cluster_id            = ""
  email_brand_color         = ""
  email_brand_logo          = ""
  email_queue_batch_size    = ""
  enable_cron               = ""
  from_email                = ""
  idp_name                  = ""
  internal_alb_dns_name     = ""
  internal_alb_listener_arn = ""
  mailer_host               = ""
  mailer_password           = ""
  mailer_usefiles           = ""
  mailer_username           = ""
  memory_api                = ""
  memory_cron               = ""
  mysql_host                = ""
  mysql_pass                = ""
  mysql_user                = ""
  notification_email        = ""
  ssl_policy                = ""
  subdomain                 = ""
  vpc_id                    = ""
  wildcard_cert_arn         = ""
}
