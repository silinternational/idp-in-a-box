/*
 * Create target group for ALB
 */
resource "aws_alb_target_group" "broker" {
  name                 = "${replace("tg-${var.idp_name}-${var.app_name}-${var.app_env}", "/(.{0,32})(.*)/", "$1")}"
  port                 = "80"
  protocol             = "HTTP"
  vpc_id               = "${var.vpc_id}"
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
  listener_arn = "${var.internal_alb_listener_arn}"
  priority     = "40"

  action {
    target_group_arn = "${aws_alb_target_group.broker.arn}"
    type             = "forward"
  }

  condition {
    field  = "host-header"
    values = ["${var.subdomain}.${var.cloudflare_domain}"]
  }
}

/*
 * Generate access tokens for consuming apps
 */
resource "random_id" "access_token_pwmanager" {
  byte_length = 16
}

resource "random_id" "access_token_ssp" {
  byte_length = 16
}

resource "random_id" "access_token_idsync" {
  byte_length = 16
}

/*
 * Create Logentries log
 */
resource "logentries_log" "log" {
  logset_id = "${var.logentries_set_id}"
  name      = "${var.app_name}"
  source    = "token"
}

/*
 * Create ECS service
 */
data "template_file" "task_def" {
  template = "${file("${path.module}/task-definition.json")}"

  vars {
    api_access_keys             = "${random_id.access_token_pwmanager.hex},${random_id.access_token_ssp.hex},${random_id.access_token_idsync.hex}"
    app_env                     = "${var.app_env}"
    idp_name                    = "${var.idp_name}"
    db_name                     = "${var.db_name}"
    docker_image                = "${var.docker_image}"
    email_service_accessToken   = "${var.email_service_accessToken}"
    email_service_assertValidIp = "${var.email_service_assertValidIp}"
    email_service_baseUrl       = "${var.email_service_baseUrl}"
    email_service_validIpRanges = "${join(",", var.email_service_validIpRanges)}"
    ldap_admin_password         = "${var.ldap_admin_password}"
    ldap_admin_username         = "${var.ldap_admin_username}"
    ldap_base_dn                = "${var.ldap_base_dn}"
    ldap_domain_controllers     = "${var.ldap_domain_controllers}"
    ldap_use_ssl                = "${var.ldap_use_ssl}"
    ldap_use_tls                = "${var.ldap_use_tls}"
    logentries_key              = "${logentries_log.log.token}"
    mfa_totp_apibaseurl         = "${var.mfa_totp_apibaseurl}"
    mfa_totp_apikey             = "${var.mfa_totp_apikey}"
    mfa_totp_apisecret          = "${var.mfa_totp_apisecret}"
    mfa_u2f_apibaseurl          = "${var.mfa_u2f_apibaseurl}"
    mfa_u2f_apikey              = "${var.mfa_u2f_apikey}"
    mfa_u2f_apisecret           = "${var.mfa_u2f_apisecret}"
    mfa_u2f_appid               = "${var.mfa_u2f_appid}"
    migrate_pw_from_ldap        = "${var.migrate_pw_from_ldap}"
    mysql_host                  = "${var.mysql_host}"
    mysql_user                  = "${var.mysql_user}"
    mysql_pass                  = "${var.mysql_pass}"
    memory                      = "${var.memory}"
    notification_email          = "${var.notification_email}"
    cpu                         = "${var.cpu}"
  }
}

module "ecsservice" {
  source             = "github.com/silinternational/terraform-modules//aws/ecs/service-only?ref=1.1.3"
  cluster_id         = "${var.ecs_cluster_id}"
  service_name       = "${var.idp_name}-${var.app_name}"
  service_env        = "${var.app_env}"
  ecsServiceRole_arn = "${var.ecsServiceRole_arn}"
  container_def_json = "${data.template_file.task_def.rendered}"
  desired_count      = "${var.desired_count}"
  tg_arn             = "${aws_alb_target_group.broker.arn}"
  lb_container_name  = "web"
  lb_container_port  = "80"
}

/*
 * Create ECS service
 */
data "template_file" "task_def_cron" {
  template = "${file("${path.module}/task-definition-cron.json")}"

  vars {
    api_access_keys             = "${random_id.access_token_pwmanager.hex},${random_id.access_token_ssp.hex},${random_id.access_token_idsync.hex}"
    app_env                     = "${var.app_env}"
    idp_name                    = "${var.idp_name}"
    cpu_cron                    = "${var.cpu_cron}"
    db_name                     = "${var.db_name}"
    docker_image                = "${var.docker_image}"
    email_service_accessToken   = "${var.email_service_accessToken}"
    email_service_assertValidIp = "${var.email_service_assertValidIp}"
    email_service_baseUrl       = "${var.email_service_baseUrl}"
    email_service_validIpRanges = "${join(",", var.email_service_validIpRanges)}"
    ldap_admin_password         = "${var.ldap_admin_password}"
    ldap_admin_username         = "${var.ldap_admin_username}"
    ldap_base_dn                = "${var.ldap_base_dn}"
    ldap_domain_controllers     = "${var.ldap_domain_controllers}"
    ldap_use_ssl                = "${var.ldap_use_ssl}"
    ldap_use_tls                = "${var.ldap_use_tls}"
    logentries_key              = "${logentries_log.log.token}"
    memory_cron                 = "${var.memory_cron}"
    mfa_totp_apibaseurl         = "${var.mfa_totp_apibaseurl}"
    mfa_totp_apikey             = "${var.mfa_totp_apikey}"
    mfa_totp_apisecret          = "${var.mfa_totp_apisecret}"
    mfa_u2f_apibaseurl          = "${var.mfa_u2f_apibaseurl}"
    mfa_u2f_apikey              = "${var.mfa_u2f_apikey}"
    mfa_u2f_apisecret           = "${var.mfa_u2f_apisecret}"
    mfa_u2f_appid               = "${var.mfa_u2f_appid}"
    migrate_pw_from_ldap        = "${var.migrate_pw_from_ldap}"
    mysql_host                  = "${var.mysql_host}"
    mysql_user                  = "${var.mysql_user}"
    mysql_pass                  = "${var.mysql_pass}"
    notification_email          = "${var.notification_email}"
  }
}

module "ecsservice_cron" {
  source             = "github.com/silinternational/terraform-modules//aws/ecs/service-no-alb?ref=1.1.3"
  cluster_id         = "${var.ecs_cluster_id}"
  service_name       = "${var.idp_name}-${var.app_name}-cron"
  service_env        = "${var.app_env}"
  container_def_json = "${data.template_file.task_def_cron.rendered}"
  desired_count      = 1
}

/*
 * Create Cloudflare DNS record
 */
resource "cloudflare_record" "brokerdns" {
  domain  = "${var.cloudflare_domain}"
  name    = "${var.subdomain}"
  value   = "${var.internal_alb_dns_name}"
  type    = "CNAME"
  proxied = false
}
