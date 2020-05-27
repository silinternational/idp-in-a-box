/*
 * Create target group for ALB
 */
resource "aws_alb_target_group" "broker" {
  name = replace(
    "tg-${var.idp_name}-${var.app_name}-${var.app_env}",
    "/(.{0,32})(.*)/",
    "$1",
  )
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
resource "aws_alb_listener_rule" "broker" {
  listener_arn = var.internal_alb_listener_arn
  priority     = "40"

  action {
    target_group_arn = aws_alb_target_group.broker.arn
    type             = "forward"
  }

  condition {
    host_header {
      values = ["${var.subdomain}.${var.cloudflare_domain}"]
    }
  }
}

/*
 * Generate access tokens for consuming apps
 */
resource "random_id" "access_token_pwmanager" {
  byte_length = 16
}

resource "random_id" "access_token_search" {
  byte_length = 16
}

resource "random_id" "access_token_ssp" {
  byte_length = 16
}

resource "random_id" "access_token_idsync" {
  byte_length = 16
}

data "template_file" "env_vars" {
  count    = length(var.google_config)
  template = file("${path.module}/envvar.json")

  vars = {
    name  = "GOOGLE_${element(keys(var.google_config), count.index)}"
    value = element(values(var.google_config), count.index)
  }
}

/*
 * Create ECS service
 */
data "template_file" "task_def" {
  template = file("${path.module}/task-definition.json")

  vars = {
    api_access_keys                  = "${random_id.access_token_pwmanager.hex},${random_id.access_token_search.hex},${random_id.access_token_ssp.hex},${random_id.access_token_idsync.hex}"
    app_env                          = var.app_env
    app_name                         = var.app_name
    aws_region                       = var.aws_region
    cloudwatch_log_group_name        = var.cloudwatch_log_group_name
    contingent_user_duration         = var.contingent_user_duration
    cpu                              = var.cpu
    db_name                          = var.db_name
    docker_image                     = var.docker_image
    email_repeat_delay_days          = var.email_repeat_delay_days
    email_service_accessToken        = var.email_service_accessToken
    email_service_assertValidIp      = var.email_service_assertValidIp
    email_service_baseUrl            = var.email_service_baseUrl
    email_service_validIpRanges      = join(",", var.email_service_validIpRanges)
    email_signature                  = var.email_signature
    ga_client_id                     = var.ga_client_id
    ga_tracking_id                   = var.ga_tracking_id
    google_config                    = join(",", data.template_file.env_vars.*.rendered)
    help_center_url                  = var.help_center_url
    hibp_check_interval              = var.hibp_check_interval
    hibp_check_on_login              = var.hibp_check_on_login
    hibp_grace_period                = var.hibp_grace_period
    hibp_tracking_only               = var.hibp_tracking_only
    hibp_notification_bcc            = var.hibp_notification_bcc
    idp_display_name                 = var.idp_display_name
    idp_name                         = var.idp_name
    inactive_user_period             = var.inactive_user_period
    inactive_user_deletion_enable    = var.inactive_user_deletion_enable
    invite_email_delay_seconds       = var.invite_email_delay_seconds
    invite_grace_period              = var.invite_grace_period
    invite_lifespan                  = var.invite_lifespan
    lost_security_key_email_days     = var.lost_security_key_email_days
    memory                           = var.memory
    method_add_interval              = var.method_add_interval
    method_codeLength                = var.method_codeLength
    method_gracePeriod               = var.method_gracePeriod
    method_lifetime                  = var.method_lifetime
    method_maxAttempts               = var.method_maxAttempts
    mfa_add_interval                 = var.mfa_add_interval
    mfa_allow_disable                = var.mfa_allow_disable
    mfa_lifetime                     = var.mfa_lifetime
    mfa_manager_bcc                  = var.mfa_manager_bcc
    mfa_manager_help_bcc             = var.mfa_manager_help_bcc
    mfa_required_for_new_users       = var.mfa_required_for_new_users
    mfa_totp_apibaseurl              = var.mfa_totp_apibaseurl
    mfa_totp_apikey                  = var.mfa_totp_apikey
    mfa_totp_apisecret               = var.mfa_totp_apisecret
    mfa_u2f_apibaseurl               = var.mfa_u2f_apibaseurl
    mfa_u2f_apikey                   = var.mfa_u2f_apikey
    mfa_u2f_apisecret                = var.mfa_u2f_apisecret
    mfa_u2f_appid                    = var.mfa_u2f_appid
    minimum_backup_codes_before_nag  = var.minimum_backup_codes_before_nag
    mysql_host                       = var.mysql_host
    mysql_pass                       = var.mysql_pass
    mysql_user                       = var.mysql_user
    name                             = "web"
    notification_email               = var.notification_email
    password_expiration_grace_period = var.password_expiration_grace_period
    password_lifespan                = var.password_lifespan
    password_mfa_lifespan_extension  = var.password_mfa_lifespan_extension
    password_profile_url             = var.password_profile_url
    password_reuse_limit             = var.password_reuse_limit
    profile_review_interval          = var.profile_review_interval
    run_task                         = ""
    send_get_backup_codes_emails     = var.send_get_backup_codes_emails
    send_invite_emails               = var.send_invite_emails
    send_lost_security_key_emails    = var.send_lost_security_key_emails
    send_method_purged_emails        = var.send_method_purged_emails
    send_method_reminder_emails      = var.send_method_reminder_emails
    send_mfa_disabled_emails         = var.send_mfa_disabled_emails
    send_mfa_enabled_emails          = var.send_mfa_enabled_emails
    send_mfa_option_added_emails     = var.send_mfa_option_added_emails
    send_mfa_option_removed_emails   = var.send_mfa_option_removed_emails
    send_mfa_rate_limit_emails       = var.send_mfa_rate_limit_emails
    send_password_changed_emails     = var.send_password_changed_emails
    send_password_expired_emails     = var.send_password_expired_emails
    send_password_expiring_emails    = var.send_password_expiring_emails
    send_refresh_backup_codes_emails = var.send_refresh_backup_codes_emails
    send_welcome_emails              = var.send_welcome_emails
    subject_for_get_backup_codes     = var.subject_for_get_backup_codes
    subject_for_invite               = var.subject_for_invite
    subject_for_lost_security_key    = var.subject_for_lost_security_key
    subject_for_method_purged        = var.subject_for_method_purged
    subject_for_method_reminder      = var.subject_for_method_reminder
    subject_for_method_verify        = var.subject_for_method_verify
    subject_for_mfa_disabled         = var.subject_for_mfa_disabled
    subject_for_mfa_enabled          = var.subject_for_mfa_enabled
    subject_for_mfa_manager          = var.subject_for_mfa_manager
    subject_for_mfa_manager_help     = var.subject_for_mfa_manager_help
    subject_for_mfa_option_added     = var.subject_for_mfa_option_added
    subject_for_mfa_option_removed   = var.subject_for_mfa_option_removed
    subject_for_mfa_rate_limit       = var.subject_for_mfa_rate_limit
    subject_for_password_changed     = var.subject_for_password_changed
    subject_for_password_expired     = var.subject_for_password_expired
    subject_for_password_expiring    = var.subject_for_password_expiring
    subject_for_refresh_backup_codes = var.subject_for_refresh_backup_codes
    subject_for_welcome              = var.subject_for_welcome
    support_email                    = var.support_email
    support_name                     = var.support_name
  }
}

module "ecsservice" {
  source             = "github.com/silinternational/terraform-modules//aws/ecs/service-only?ref=3.0.1"
  cluster_id         = var.ecs_cluster_id
  service_name       = "${var.idp_name}-${var.app_name}"
  service_env        = var.app_env
  ecsServiceRole_arn = var.ecsServiceRole_arn
  container_def_json = data.template_file.task_def.rendered
  desired_count      = var.desired_count
  tg_arn             = aws_alb_target_group.broker.arn
  lb_container_name  = "web"
  lb_container_port  = "80"
}

/*
 * Create ECS service
 */
data "template_file" "task_def_cron" {
  template = file("${path.module}/task-definition.json")

  vars = {
    api_access_keys                  = "${random_id.access_token_pwmanager.hex},${random_id.access_token_ssp.hex},${random_id.access_token_idsync.hex}"
    app_env                          = var.app_env
    app_name                         = var.app_name
    aws_region                       = var.aws_region
    cloudwatch_log_group_name        = var.cloudwatch_log_group_name
    cpu                              = var.cpu_cron
    contingent_user_duration         = var.contingent_user_duration
    db_name                          = var.db_name
    docker_image                     = var.docker_image
    email_repeat_delay_days          = var.email_repeat_delay_days
    email_service_accessToken        = var.email_service_accessToken
    email_service_assertValidIp      = var.email_service_assertValidIp
    email_service_baseUrl            = var.email_service_baseUrl
    email_service_validIpRanges      = join(",", var.email_service_validIpRanges)
    email_signature                  = var.email_signature
    ga_client_id                     = var.ga_client_id
    ga_tracking_id                   = var.ga_tracking_id
    google_config                    = join(",", data.template_file.env_vars.*.rendered)
    help_center_url                  = var.help_center_url
    hibp_check_interval              = var.hibp_check_interval
    hibp_check_on_login              = var.hibp_check_on_login
    hibp_grace_period                = var.hibp_grace_period
    hibp_tracking_only               = var.hibp_tracking_only
    hibp_notification_bcc            = var.hibp_notification_bcc
    idp_display_name                 = var.idp_display_name
    idp_name                         = var.idp_name
    inactive_user_period             = var.inactive_user_period
    inactive_user_deletion_enable    = var.inactive_user_deletion_enable
    invite_email_delay_seconds       = var.invite_email_delay_seconds
    invite_grace_period              = var.invite_grace_period
    invite_lifespan                  = var.invite_lifespan
    lost_security_key_email_days     = var.lost_security_key_email_days
    memory                           = var.memory_cron
    method_add_interval              = var.method_add_interval
    method_codeLength                = var.method_codeLength
    method_gracePeriod               = var.method_gracePeriod
    method_lifetime                  = var.method_lifetime
    method_maxAttempts               = var.method_maxAttempts
    mfa_add_interval                 = var.mfa_add_interval
    mfa_allow_disable                = var.mfa_allow_disable
    mfa_lifetime                     = var.mfa_lifetime
    mfa_manager_bcc                  = var.mfa_manager_bcc
    mfa_manager_help_bcc             = var.mfa_manager_help_bcc
    mfa_required_for_new_users       = var.mfa_required_for_new_users
    mfa_totp_apibaseurl              = var.mfa_totp_apibaseurl
    mfa_totp_apikey                  = var.mfa_totp_apikey
    mfa_totp_apisecret               = var.mfa_totp_apisecret
    mfa_u2f_apibaseurl               = var.mfa_u2f_apibaseurl
    mfa_u2f_apikey                   = var.mfa_u2f_apikey
    mfa_u2f_apisecret                = var.mfa_u2f_apisecret
    mfa_u2f_appid                    = var.mfa_u2f_appid
    minimum_backup_codes_before_nag  = var.minimum_backup_codes_before_nag
    mysql_host                       = var.mysql_host
    mysql_pass                       = var.mysql_pass
    mysql_user                       = var.mysql_user
    name                             = "cron"
    notification_email               = var.notification_email
    password_expiration_grace_period = var.password_expiration_grace_period
    password_lifespan                = var.password_lifespan
    password_mfa_lifespan_extension  = var.password_mfa_lifespan_extension
    password_profile_url             = var.password_profile_url
    password_reuse_limit             = var.password_reuse_limit
    profile_review_interval          = var.profile_review_interval
    run_task                         = var.run_task
    send_get_backup_codes_emails     = var.send_get_backup_codes_emails
    send_invite_emails               = var.send_invite_emails
    send_lost_security_key_emails    = var.send_lost_security_key_emails
    send_method_purged_emails        = var.send_method_purged_emails
    send_method_reminder_emails      = var.send_method_reminder_emails
    send_mfa_disabled_emails         = var.send_mfa_disabled_emails
    send_mfa_enabled_emails          = var.send_mfa_enabled_emails
    send_mfa_option_added_emails     = var.send_mfa_option_added_emails
    send_mfa_option_removed_emails   = var.send_mfa_option_removed_emails
    send_mfa_rate_limit_emails       = var.send_mfa_rate_limit_emails
    send_password_changed_emails     = var.send_password_changed_emails
    send_password_expired_emails     = var.send_password_expired_emails
    send_password_expiring_emails    = var.send_password_expiring_emails
    send_refresh_backup_codes_emails = var.send_refresh_backup_codes_emails
    send_welcome_emails              = var.send_welcome_emails
    subject_for_get_backup_codes     = var.subject_for_get_backup_codes
    subject_for_invite               = var.subject_for_invite
    subject_for_lost_security_key    = var.subject_for_lost_security_key
    subject_for_method_purged        = var.subject_for_method_purged
    subject_for_method_reminder      = var.subject_for_method_reminder
    subject_for_method_verify        = var.subject_for_method_verify
    subject_for_mfa_disabled         = var.subject_for_mfa_disabled
    subject_for_mfa_enabled          = var.subject_for_mfa_enabled
    subject_for_mfa_manager          = var.subject_for_mfa_manager
    subject_for_mfa_manager_help     = var.subject_for_mfa_manager_help
    subject_for_mfa_option_added     = var.subject_for_mfa_option_added
    subject_for_mfa_option_removed   = var.subject_for_mfa_option_removed
    subject_for_mfa_rate_limit       = var.subject_for_mfa_rate_limit
    subject_for_password_changed     = var.subject_for_password_changed
    subject_for_password_expired     = var.subject_for_password_expired
    subject_for_password_expiring    = var.subject_for_password_expiring
    subject_for_refresh_backup_codes = var.subject_for_refresh_backup_codes
    subject_for_welcome              = var.subject_for_welcome
    support_email                    = var.support_email
    support_name                     = var.support_name
  }
}

/*
 * Create role for scheduled running of cron task definitions.
 */
resource "aws_iam_role" "ecs_events" {
  name = "ecs_events-${var.idp_name}-${var.app_name}-${var.app_env}"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
              "Service": "events.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF

}

resource "aws_iam_role_policy" "ecs_events_run_task_with_any_role" {
  name = "ecs_events_run_task_with_any_role"
  role = aws_iam_role.ecs_events.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "iam:PassRole",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "ecs:RunTask",
            "Resource": "${replace(aws_ecs_task_definition.cron_td.arn, "/:\\d+$/", ":*")}"
        }
    ]
}
EOF

}

/*
 * Create cron task definition
 */
resource "aws_ecs_task_definition" "cron_td" {
  family                = "${var.idp_name}-${var.app_name}-cron-${var.app_env}"
  container_definitions = data.template_file.task_def_cron.rendered
  network_mode          = "bridge"
}

/*
 * CloudWatch configuration to start scheduled tasks.
 */
resource "aws_cloudwatch_event_rule" "event_rule" {
  name        = "${var.idp_name}-${var.app_name}-cron-${var.app_env}"
  description = "Start broker scheduled tasks"

  schedule_expression = var.event_schedule

  tags = {
    app_name = var.app_name
    app_env  = var.app_env
  }
}

resource "aws_cloudwatch_event_target" "broker_event_target" {
  target_id = "${var.idp_name}-${var.app_name}-cron-${var.app_env}"
  rule      = aws_cloudwatch_event_rule.event_rule.name
  arn       = var.ecs_cluster_id
  role_arn  = aws_iam_role.ecs_events.arn

  ecs_target {
    task_count          = 1
    launch_type         = "EC2"
    task_definition_arn = aws_ecs_task_definition.cron_td.arn
  }
}

/*
 * Create Cloudflare DNS record
 */
resource "cloudflare_record" "brokerdns" {
  domain  = var.cloudflare_domain
  name    = var.subdomain
  value   = var.internal_alb_dns_name
  type    = "CNAME"
  proxied = false
}
