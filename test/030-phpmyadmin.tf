module "pma" {
  source = "../terraform/030-phpmyadmin"

  app_name               = ""
  alb_dns_name           = ""
  alb_https_listener_arn = ""
  app_env                = ""
  cloudflare_domain      = ""
  cpu                    = ""
  ecsServiceRole_arn     = ""
  ecs_cluster_id         = ""
  enable                 = true
  idp_name               = ""
  memory                 = ""
  rds_address            = ""
  subdomain              = ""
  upload_limit           = ""
  vpc_id                 = ""
}
