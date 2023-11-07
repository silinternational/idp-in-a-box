/*
 * Create ECS service
 */
locals {
  id_store_config = join(",",
    [for k, v in var.id_store_config : jsonencode({
      name  = "ID_STORE_CONFIG_${k}"
      value = v
    })]
  )

  task_def = templatefile("${path.module}/task-definition.json", {
    app_env                      = var.app_env
    app_name                     = var.app_name
    aws_region                   = var.aws_region
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
    id_store_config              = local.id_store_config
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
  })
}

/*
 * Create role for scheduled running of cron task definitions.
 */
resource "aws_iam_role" "ecs_events" {
  name = "ecs_events-${var.idp_name}-${var.app_name}-${var.app_env}-${var.aws_region}"

  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Sid    = ""
          Effect = "Allow"
          Principal = {
            Service = "events.amazonaws.com"
          }
          Action = "sts:AssumeRole"
        },
      ]
    }
  )
}

resource "aws_iam_role_policy" "ecs_events_run_task_with_any_role" {
  name = "ecs_events_run_task_with_any_role"
  role = aws_iam_role.ecs_events.id

  policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Effect   = "Allow"
          Action   = "iam:PassRole"
          Resource = "*"
        },
        {
          Effect   = "Allow"
          Action   = "ecs:RunTask"
          Resource = "${aws_ecs_task_definition.cron_td.arn_without_revision}:*"
        },
      ]
    }
  )

}

/*
 * Create cron task definition
 */
resource "aws_ecs_task_definition" "cron_td" {
  family                = "${var.idp_name}-${var.app_name}-cron-${var.app_env}"
  container_definitions = local.task_def
  network_mode          = "bridge"
}

/*
 * CloudWatch configuration to start scheduled tasks.
 */
resource "aws_cloudwatch_event_rule" "event_rule" {
  name        = "${var.idp_name}-${var.app_name}-${var.app_env}"
  description = "Start ID Sync scheduled tasks"

  schedule_expression = var.event_schedule

  tags = {
    app_name = var.app_name
    app_env  = var.app_env
  }
}

resource "aws_cloudwatch_event_target" "broker_event_target" {
  target_id = "${var.idp_name}-${var.app_name}-${var.app_env}"
  rule      = aws_cloudwatch_event_rule.event_rule.name
  arn       = var.ecs_cluster_id
  role_arn  = aws_iam_role.ecs_events.arn

  ecs_target {
    task_count          = 1
    launch_type         = "EC2"
    task_definition_arn = aws_ecs_task_definition.cron_td.arn
  }
}
