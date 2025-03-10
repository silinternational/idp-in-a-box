locals {
  aws_account          = data.aws_caller_identity.this.account_id
  aws_region           = data.aws_region.current.name
  ui_hostname          = "${var.ui_subdomain}.${var.cloudflare_domain}"
  config_id_or_null    = one(aws_appconfig_configuration_profile.this[*].configuration_profile_id)
  appconfig_config_id  = local.config_id_or_null == null ? "" : local.config_id_or_null
  parameter_store_path = "/idp-${var.idp_name}/"
}

/*
 * Create target group for ALB
 */
resource "aws_alb_target_group" "pwmanager" {
  name                 = substr("tg-${var.idp_name}-${var.app_name}-${var.app_env}", 0, 32)
  port                 = "80"
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  deregistration_delay = "30"

  stickiness {
    type = "lb_cookie"
  }

  health_check {
    path    = "/site/system-status"
    matcher = "200"
  }
}

/*
 * Create listener rule for hostname routing to new target group
 */
resource "aws_alb_listener_rule" "pwmanager" {
  listener_arn = var.alb_https_listener_arn
  priority     = "50"

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.pwmanager.arn
  }

  condition {
    host_header {
      values = [
        "${var.api_subdomain}.${var.cloudflare_domain}",
        "${local.api_subdomain_with_region}.${var.cloudflare_domain}"
      ]
    }
  }
}

/*
 * Generate access token hash used for generating user access tokens
 */
resource "random_id" "access_token_hash" {
  byte_length = 16
}

/*
 * Create ECS service for API
 */
locals {
  api_subdomain_with_region = "${var.api_subdomain}-${local.aws_region}"

  task_def = templatefile("${path.module}/task-definition-api.json", {
    appconfig_app_id                    = var.appconfig_app_id
    appconfig_env_id                    = var.appconfig_env_id
    appconfig_config_id                 = local.appconfig_config_id
    access_token_hash                   = random_id.access_token_hash.hex
    alerts_email                        = var.alerts_email
    alerts_email_enabled                = var.alerts_email_enabled
    app_env                             = var.app_env
    app_name                            = var.app_name
    aws_region                          = local.aws_region
    cloudwatch_log_group_name           = var.cloudwatch_log_group_name
    auth_saml_checkResponseSigning      = var.auth_saml_checkResponseSigning
    auth_saml_entityId                  = coalesce(var.auth_saml_entityId, "${var.api_subdomain}.${var.cloudflare_domain}")
    auth_saml_idpCertificate            = var.auth_saml_idpCertificate
    auth_saml_requireEncryptedAssertion = var.auth_saml_requireEncryptedAssertion
    auth_saml_signRequest               = var.auth_saml_signRequest
    auth_saml_sloUrl                    = coalesce(var.auth_saml_sloUrl, "${var.auth_saml_idp_url}/saml2/idp/SingleLogoutService.php")
    auth_saml_spCertificate             = var.auth_saml_spCertificate
    auth_saml_spPrivateKey              = var.auth_saml_spPrivateKey
    auth_saml_ssoUrl                    = coalesce(var.auth_saml_ssoUrl, "${var.auth_saml_idp_url}/saml2/idp/SSOService.php")
    cmd                                 = "/data/run.sh"
    code_length                         = var.code_length
    cpu                                 = var.cpu
    db_name                             = var.db_name
    docker_image                        = var.docker_image
    email_service_accessToken           = var.email_service_accessToken
    email_service_assertValidIp         = var.email_service_assertValidIp
    email_service_baseUrl               = var.email_service_baseUrl
    email_service_validIpRanges         = join(",", var.email_service_validIpRanges)
    email_signature                     = var.email_signature
    extra_hosts                         = var.extra_hosts
    help_center_url                     = var.help_center_url
    id_broker_access_token              = var.id_broker_access_token
    id_broker_assertValidBrokerIp       = var.id_broker_assertValidBrokerIp
    id_broker_base_uri                  = var.id_broker_base_uri
    id_broker_validIpRanges             = join(",", var.id_broker_validIpRanges)
    idp_display_name                    = var.idp_display_name
    idp_name                            = var.idp_name
    memory                              = var.memory
    mysql_host                          = var.mysql_host
    mysql_password                      = var.mysql_pass
    mysql_user                          = var.mysql_user
    parameter_store_path                = local.parameter_store_path
    password_rule_alpha_and_numeric     = var.password_rule_alpha_and_numeric
    password_rule_enablehibp            = var.password_rule_enablehibp
    password_rule_maxlength             = var.password_rule_maxlength
    password_rule_minlength             = var.password_rule_minlength
    password_rule_minscore              = var.password_rule_minscore
    recaptcha_secret_key                = var.recaptcha_secret
    recaptcha_site_key                  = var.recaptcha_key
    sentry_dsn                          = var.sentry_dsn
    support_email                       = var.support_email
    support_feedback                    = var.support_feedback
    support_name                        = var.support_name
    support_phone                       = var.support_phone
    support_url                         = var.support_url
    ui_cors_origin                      = "https://${local.ui_hostname}"
    ui_url                              = "https://${local.ui_hostname}/#"
  })
}

module "ecsservice" {
  source             = "github.com/silinternational/terraform-modules//aws/ecs/service-only?ref=8.13.2"
  cluster_id         = var.ecs_cluster_id
  service_name       = "${var.idp_name}-${var.app_name}"
  service_env        = var.app_env
  container_def_json = local.task_def
  desired_count      = var.desired_count
  tg_arn             = aws_alb_target_group.pwmanager.arn
  lb_container_name  = "web"
  lb_container_port  = "80"
  ecsServiceRole_arn = var.ecsServiceRole_arn
  task_role_arn      = module.ecs_role.role_arn
}

/*
 * Create Cloudflare DNS record(s)
 */
resource "cloudflare_record" "apidns" {
  count = var.create_dns_record ? 1 : 0

  zone_id = data.cloudflare_zone.domain.id
  name    = var.api_subdomain
  value   = cloudflare_record.apidns_intermediate.hostname
  type    = "CNAME"
  proxied = true
}

resource "cloudflare_record" "apidns_intermediate" {
  zone_id = data.cloudflare_zone.domain.id
  name    = local.api_subdomain_with_region
  value   = var.alb_dns_name
  type    = "CNAME"
  proxied = true
}

data "cloudflare_zone" "domain" {
  name = var.cloudflare_domain
}


/*
 * Create ECS role
 */
module "ecs_role" {
  source = "../ecs-role"

  name = "ecs-${var.idp_name}-${var.app_name}-${var.app_env}-${local.aws_region}"
}

moved {
  from = module.ecs_role[0]
  to   = module.ecs_role
}

resource "aws_iam_role_policy" "this" {
  count = var.appconfig_app_id == "" ? 0 : 1

  name = "appconfig"
  role = module.ecs_role.role_name
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

resource "aws_iam_role_policy" "parameter_store" {
  name = "parameter-store"
  role = module.ecs_role.role_name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid    = "ParameterStore"
      Effect = "Allow"
      Action = [
        "ssm:GetParametersByPath",
      ]
      Resource = "arn:aws:ssm:*:${local.aws_account}:parameter${local.parameter_store_path}*"
    }]
  })
}

resource "aws_iam_user_policy_attachment" "cd" {
  user       = var.cduser_username
  policy_arn = aws_iam_policy.cd.arn
}

resource "aws_iam_policy" "cd" {
  name = "cd-policy-${var.idp_name}-${var.app_name}-${var.app_env}-${local.aws_region}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ECS"
        Effect = "Allow"
        Action = [
          "ecs:DescribeServices",
          "ecs:UpdateService",
          "ecs:RegisterTaskDefinition",
        ]
        Resource = [
          module.ecsservice.service_id,
          "arn:aws:ecs:${local.aws_region}:${local.aws_account}:task-definition/${module.ecsservice.task_def_family}:*",
        ]
      },
      {
        Sid      = "PassRole"
        Effect   = "Allow"
        Action   = "iam:PassRole"
        Resource = module.ecs_role.role_arn
      },
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
