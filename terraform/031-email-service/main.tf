locals {
  aws_account         = data.aws_caller_identity.this.account_id
  aws_region          = data.aws_region.current.name
  config_id_or_null   = one(aws_appconfig_configuration_profile.this[*].configuration_profile_id)
  appconfig_config_id = local.config_id_or_null == null ? "" : local.config_id_or_null
}

/*
 * Create target group for ALB
 */
resource "aws_alb_target_group" "email" {
  name                 = substr("tg-${var.idp_name}-${var.app_name}-${var.app_env}", 0, 32)
  port                 = "80"
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  deregistration_delay = "30"

  health_check {
    path    = "/site/status"
    matcher = "200,204"
  }
}

/*
 * Create listener rule for hostname routing to new target group
 */
resource "aws_alb_listener_rule" "email" {
  listener_arn = var.internal_alb_listener_arn
  priority     = "31"

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.email.arn
  }

  condition {
    host_header {
      values = [
        "${local.subdomain_with_region}.${var.cloudflare_domain}"
      ]
    }
  }
}

/*
 * Generate access tokens for consuming apps
 */
resource "random_id" "access_token_pwmanager" {
  byte_length = 16
}

resource "random_id" "access_token_idbroker" {
  byte_length = 16
}

resource "random_id" "access_token_idsync" {
  byte_length = 16
}


/*
 * Create ECS role
 */
module "ecs_role" {
  source = "../ecs-role"

  name = "ecs-${var.idp_name}-${var.app_name}-${var.app_env}-${local.aws_region}"
}

resource "aws_iam_role_policy" "ses" {
  name = "ses"
  role = module.ecs_role.role_name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid      = "SendEmail"
      Effect   = "Allow"
      Action   = "ses:SendEmail"
      Resource = "*"
      Condition = {
        StringEquals = {
          "ses:FromAddress" = var.from_email
        }
      }
    }]
  })
}

resource "aws_iam_role_policy" "appconfig" {
  count = var.appconfig_app_id == "" ? 0 : 1

  name = "appconfig"
  role = module.ecs_role.role_name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid    = "AppConfig"
      Effect = "Allow"
      Action = [
        "appconfig:GetLatestConfiguration",
        "appconfig:StartConfigurationSession",
      ]
      Resource = "arn:aws:appconfig:${local.aws_region}:${local.aws_account}:application/${var.appconfig_app_id}/environment/${var.appconfig_env_id}/configuration/${local.appconfig_config_id}"
    }]
  })
}


/*
 * Create ECS services
 */
locals {
  subdomain_with_region = "${var.subdomain}-${local.aws_region}"

  task_def_api = templatefile("${path.module}/task-definition-api.json", {
    appconfig_app_id          = var.appconfig_app_id
    appconfig_env_id          = var.appconfig_env_id
    appconfig_config_id       = local.appconfig_config_id
    api_access_keys           = "${random_id.access_token_pwmanager.hex},${random_id.access_token_idbroker.hex},${random_id.access_token_idsync.hex}"
    app_env                   = var.app_env
    app_name                  = var.app_name
    aws_region                = local.aws_region
    cloudwatch_log_group_name = var.cloudwatch_log_group_name
    cpu_api                   = var.cpu_api
    db_name                   = var.db_name
    docker_image              = var.docker_image
    email_brand_color         = var.email_brand_color
    email_brand_logo          = var.email_brand_logo
    email_queue_batch_size    = var.email_queue_batch_size
    from_name                 = var.from_name
    from_email                = var.from_email
    idp_name                  = var.idp_name
    mailer_host               = var.mailer_host
    mailer_password           = var.mailer_password
    mailer_usefiles           = var.mailer_usefiles
    mailer_username           = var.mailer_username
    mysql_host                = var.mysql_host
    mysql_pass                = var.mysql_pass
    mysql_user                = var.mysql_user
    memory_api                = var.memory_api
    notification_email        = var.notification_email
  })
}

module "ecsservice_api" {
  source             = "github.com/silinternational/terraform-modules//aws/ecs/service-only?ref=8.13.2"
  cluster_id         = var.ecs_cluster_id
  service_name       = "${var.idp_name}-${var.app_name}-api"
  service_env        = var.app_env
  ecsServiceRole_arn = var.ecsServiceRole_arn
  container_def_json = local.task_def_api
  desired_count      = var.desired_count_api
  tg_arn             = aws_alb_target_group.email.arn
  task_role_arn      = module.ecs_role.role_arn
  lb_container_name  = "api"
  lb_container_port  = "80"
}

locals {
  task_def_cron = templatefile("${path.module}/task-definition-cron.json", {
    appconfig_app_id          = var.appconfig_app_id
    appconfig_env_id          = var.appconfig_env_id
    appconfig_config_id       = local.appconfig_config_id
    api_access_keys           = "${random_id.access_token_pwmanager.hex},${random_id.access_token_idbroker.hex},${random_id.access_token_idsync.hex}"
    app_env                   = var.app_env
    app_name                  = var.app_name
    aws_region                = local.aws_region
    cloudwatch_log_group_name = var.cloudwatch_log_group_name
    cpu_cron                  = var.cpu_cron
    db_name                   = var.db_name
    docker_image              = var.docker_image
    email_brand_color         = var.email_brand_color
    email_brand_logo          = var.email_brand_logo
    email_queue_batch_size    = var.email_queue_batch_size
    from_email                = var.from_email
    from_name                 = var.from_name
    idp_name                  = var.idp_name
    mailer_host               = var.mailer_host
    mailer_password           = var.mailer_password
    mailer_usefiles           = var.mailer_usefiles
    mailer_username           = var.mailer_username
    mysql_host                = var.mysql_host
    mysql_pass                = var.mysql_pass
    mysql_user                = var.mysql_user
    memory_cron               = var.memory_cron
    notification_email        = var.notification_email
  })
}

module "ecsservice_cron" {
  source             = "github.com/silinternational/terraform-modules//aws/ecs/service-no-alb?ref=8.13.2"
  cluster_id         = var.ecs_cluster_id
  service_name       = "${var.idp_name}-${var.app_name}-cron"
  service_env        = var.app_env
  container_def_json = local.task_def_cron
  task_role_arn      = module.ecs_role.role_arn
  desired_count      = var.enable_cron ? 1 : 0
}

/*
 * Create Cloudflare DNS record(s)
 */
resource "cloudflare_record" "emaildns" {
  zone_id = data.cloudflare_zone.domain.id
  name    = local.subdomain_with_region
  value   = var.internal_alb_dns_name
  type    = "CNAME"
  proxied = false
}

data "cloudflare_zone" "domain" {
  name = var.cloudflare_domain
}


/*
 * Create AppConfig configuration profile
 */
resource "aws_appconfig_configuration_profile" "this" {
  count = var.appconfig_app_id == "" ? 0 : 1

  application_id = var.appconfig_app_id
  name           = "${var.app_name}-${var.app_env}"
  location_uri   = "hosted"
}


/*
 * AWS data
 */

data "aws_caller_identity" "this" {}

data "aws_region" "current" {}
