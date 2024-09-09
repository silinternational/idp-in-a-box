locals {
  aws_account         = data.aws_caller_identity.this.account_id
  aws_region          = data.aws_region.current.name
  config_id_or_null   = one(aws_appconfig_configuration_profile.this[*].configuration_profile_id)
  appconfig_config_id = local.config_id_or_null == null ? "" : local.config_id_or_null

  /*
   * Create ECS service
   */
  id_store_config = join(",",
    [for k, v in var.id_store_config : jsonencode({
      name  = "ID_STORE_CONFIG_${k}"
      value = v
    })]
  )

  task_def = templatefile("${path.module}/task-definition.json", {
    appconfig_app_id             = var.appconfig_app_id
    appconfig_env_id             = var.appconfig_env_id
    appconfig_config_id          = local.appconfig_config_id
    app_env                      = var.app_env
    app_name                     = var.app_name
    aws_region                   = local.aws_region
    cloudwatch_log_group_name    = var.cloudwatch_log_group_name
    docker_image                 = var.docker_image
    email_service_accessToken    = var.email_service_accessToken
    email_service_assertValidIp  = var.email_service_assertValidIp
    email_service_baseUrl        = var.email_service_baseUrl
    email_service_validIpRanges  = join(",", var.email_service_validIpRanges)
    id_broker_access_token       = var.id_broker_access_token
    id_broker_adapter            = var.id_broker_adapter
    id_broker_assertValidIp      = var.id_broker_assertValidIp
    id_broker_base_url           = var.id_broker_base_url
    id_broker_trustedIpRanges    = join(",", var.id_broker_trustedIpRanges)
    id_store_adapter             = var.id_store_adapter
    id_store_config              = local.id_store_config == "" ? "" : ",${local.id_store_config}"
    idp_name                     = var.idp_name
    idp_display_name             = var.idp_display_name
    alerts_email                 = var.alerts_email
    notifier_email_to            = var.notifier_email_to
    memory                       = var.memory
    cpu                          = var.cpu
    sync_safety_cutoff           = var.sync_safety_cutoff
    allow_empty_email            = var.allow_empty_email
    enable_new_user_notification = var.enable_new_user_notification
    sentry_dsn                   = var.sentry_dsn
    heartbeat_url                = var.heartbeat_url
    heartbeat_method             = var.heartbeat_method
  })
}

module "cron_task" {
  source                 = "../task"
  name                   = "${var.idp_name}-${var.app_name}-cron-${var.app_env}-${local.aws_region}"
  event_rule_description = "Start ID Sync scheduled tasks"
  enable                 = var.enable_sync
  event_schedule         = var.event_schedule
  ecs_cluster_arn        = var.ecs_cluster_id
  task_definition_arn    = aws_ecs_task_definition.cron_td.arn
  tags = {
    app_name = var.app_name
    app_env  = var.app_env
  }
}

moved {
  from = aws_iam_role.ecs_events
  to   = module.cron_task.aws_iam_role.this
}

moved {
  from = aws_iam_role_policy.ecs_events_run_task_with_any_role
  to   = module.cron_task.aws_iam_role_policy.this
}

/*
 * Create cron task definition
 */
resource "aws_ecs_task_definition" "cron_td" {
  family                = "${var.idp_name}-${var.app_name}-cron-${var.app_env}"
  container_definitions = local.task_def
  network_mode          = "bridge"
  task_role_arn         = one(module.ecs_role[*].role_arn)
}

moved {
  from = aws_cloudwatch_event_rule.event_rule
  to   = module.cron_task.aws_cloudwatch_event_rule.this
}

moved {
  from = aws_cloudwatch_event_target.id_sync_event_target
  to   = module.cron_task.aws_cloudwatch_event_target.this
}

/*
 * Create ECS role
 */
module "ecs_role" {
  count  = var.appconfig_app_id == "" ? 0 : 1
  source = "../ecs-role"

  name = "ecs-${var.idp_name}-${var.app_name}-${var.app_env}-${local.aws_region}"
}

resource "aws_iam_role_policy" "this" {
  count = var.appconfig_app_id == "" ? 0 : 1

  name = "appconfig"
  role = one(module.ecs_role[*].role_name)
  policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Sid    = "AppConfig"
          Effect = "Allow"
          Action = [
            "appconfig:GetLatestConfiguration",
            "appconfig:StartConfigurationSession",
          ]
          Resource = "arn:aws:appconfig:${local.aws_region}:${local.aws_account}:application/${var.appconfig_app_id}/environment/${var.appconfig_env_id}/configuration/${local.appconfig_config_id}"
        }
      ]
  })
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
