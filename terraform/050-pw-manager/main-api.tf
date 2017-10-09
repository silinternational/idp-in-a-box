/*
 * Create Logentries log
 */
resource "logentries_log" "log" {
  logset_id = "${var.logentries_set_id}"
  name      = "${var.app_name}"
  source    = "token"
}

/*
 * Create target group for ALB
 */
resource "aws_alb_target_group" "pwmanager" {
  name                 = "${replace("tg-${var.idp_name}-${var.app_name}-${var.app_env}", "/(.{0,32})(.*)/", "$1")}"
  port                 = "80"
  protocol             = "HTTP"
  vpc_id               = "${var.vpc_id}"
  deregistration_delay = "30"

  health_check {
    path    = "/site/system-status"
    matcher = "200"
  }
}

/*
 * Create listener rule for hostname routing to new target group
 */
resource "aws_alb_listener_rule" "pwmanager" {
  listener_arn = "${var.alb_https_listener_arn}"
  priority     = "50"

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.pwmanager.arn}"
  }

  condition {
    field  = "host-header"
    values = ["${var.api_subdomain}.${var.cloudflare_domain}"]
  }
}

/*
 * Generate access token for UI to use to call API
 */
resource "random_id" "access_token_hash" {
  byte_length = 16
}

/*
 * Create ECS service for API
 */
data "template_file" "task_def" {
  template = "${file("${path.module}/task-definition-api.json")}"

  vars {
    access_token_hash             = "${random_id.access_token_hash.hex}"
    idp_name                      = "${var.idp_name}"
    idp_display_name              = "${var.idp_display_name}"
    idp_username_hint             = "${var.idp_username_hint}"
    alerts_email                  = "${var.alerts_email}"
    support_email                 = "${var.support_email}"
    from_email                    = "${var.from_email}"
    from_name                     = "${var.from_name}"
    help_center_url               = "https://${cloudflare_record.uidns.hostname}/#/help"
    logo_url                      = "${var.logo_url}"
    db_name                       = "${var.db_name}"
    mysql_host                    = "${var.mysql_host}"
    mysql_user                    = "${var.mysql_user}"
    mysql_password                = "${var.mysql_pass}"
    recaptcha_site_key            = "${var.recaptcha_key}"
    recaptcha_secret_key          = "${var.recaptcha_secret}"
    logentries_key                = "${logentries_log.log.token}"
    docker_image                  = "${var.docker_image}"
    app_env                       = "${var.app_env}"
    ui_cors_origin                = "https://${var.ui_subdomain}.${var.cloudflare_domain}"
    ui_url                        = "https://${var.ui_subdomain}.${var.cloudflare_domain}/#"
    id_broker_access_token        = "${var.id_broker_access_token}"
    id_broker_base_uri            = "${var.id_broker_base_uri}"
    cmd                           = "/data/run.sh"
    memory                        = "${var.memory}"
    cpu                           = "${var.cpu}"
    email_service_useEmailService = "${var.email_service_useEmailService}"
    email_service_baseUrl         = "${var.email_service_baseUrl}"
    email_service_accessToken     = "${var.email_service_accessToken}"
    email_service_assertValidIp   = "${var.email_service_assertValidIp}"
    email_service_validIpRanges   = "${join(",", var.email_service_validIpRanges)}"
  }
}

module "ecsservice" {
  source             = "github.com/silinternational/terraform-modules//aws/ecs/service-only?ref=1.1.3"
  cluster_id         = "${var.ecs_cluster_id}"
  service_name       = "${var.idp_name}-${var.app_name}"
  service_env        = "${var.app_env}"
  container_def_json = "${data.template_file.task_def.rendered}"
  desired_count      = "${var.desired_count}"
  tg_arn             = "${aws_alb_target_group.pwmanager.arn}"
  lb_container_name  = "web"
  lb_container_port  = "80"
  ecsServiceRole_arn = "${var.ecsServiceRole_arn}"
}

/*
 * Create Cloudflare DNS record
 */
resource "cloudflare_record" "apidns" {
  domain  = "${var.cloudflare_domain}"
  name    = "${var.api_subdomain}"
  value   = "${var.alb_dns_name}"
  type    = "CNAME"
  proxied = true
}
