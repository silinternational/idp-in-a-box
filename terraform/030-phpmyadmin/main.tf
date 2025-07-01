module "phpmyadmin" {
  source                 = "silinternational/phpmyadmin/aws"
  version                = "~> 1.2"
  app_name               = "${var.idp_name}-${var.app_name}"
  app_env                = var.app_env
  vpc_id                 = var.vpc_id
  alb_https_listener_arn = var.alb_https_listener_arn
  subdomain              = var.subdomain
  cloudflare_domain      = var.cloudflare_domain
  rds_address            = var.rds_address
  ecs_cluster_id         = var.ecs_cluster_id
  ecsServiceRole_arn     = var.ecsServiceRole_arn
  alb_dns_name           = var.alb_dns_name
  enable                 = var.enable
  upload_limit           = var.upload_limit
  cpu                    = var.cpu
  memory                 = var.memory
}
