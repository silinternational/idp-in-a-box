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
resource "aws_alb_target_group" "idsync" {
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
resource "aws_alb_listener_rule" "idsync" {
  listener_arn = "${var.alb_https_listener_arn}"
  priority     = "70"

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.idsync.arn}"
  }

  condition {
    field  = "host-header"
    values = ["${var.subdomain}.${var.cloudflare_domain}"]
  }
}

/*
 * Generate access token for external system to use when calling ID Sync
 */
resource "random_id" "access_token_external" {
  byte_length = 16
}

data "template_file" "env_vars" {
  count    = "${length(var.id_store_config)}"
  template = "${file("${path.module}/envvar.json")}"

  vars {
    name  = "ID_STORE_CONFIG_${element(keys(var.id_store_config), count.index)}"
    value = "${element(values(var.id_store_config), count.index)}"
  }
}

/*
 * Create ECS service
 */
data "template_file" "task_def" {
  template = "${file("${path.module}/task-definition.json")}"

  vars {
    app_env                     = "${var.app_env}"
    docker_image                = "${var.docker_image}"
    email_service_accessToken   = "${var.email_service_accessToken}"
    email_service_assertValidIp = "${var.email_service_assertValidIp}"
    email_service_baseUrl       = "${var.email_service_baseUrl}"
    email_service_validIpRanges = "${join(",", var.email_service_validIpRanges)}"
    id_broker_access_token      = "${var.id_broker_access_token}"
    id_broker_adapter           = "${var.id_broker_adapter}"
    id_broker_assertValidIp     = "${var.id_broker_assertValidIp}"
    id_broker_base_url          = "${var.id_broker_base_url}"
    id_broker_trustedIpRanges   = "${join(",", var.id_broker_trustedIpRanges)}"
    id_store_adapter            = "${var.id_store_adapter}"
    id_store_config             = "${var.id_store_config}"
    id_sync_access_tokens       = "${random_id.access_token_external.hex}"
    idp_name                    = "${var.idp_name}"
    idp_display_name            = "${var.idp_display_name}"
    logentries_key              = "${logentries_log.log.token}"
    notifier_email_to           = "${var.notifier_email_to}"
    id_store_config             = "${join(",", data.template_file.env_vars.*.rendered)}"
    memory                      = "${var.memory}"
    cpu                         = "${var.cpu}"
    sync_safety_cutoff          = "${var.sync_safety_cutoff}"
  }
}

module "ecsservice" {
  source             = "github.com/silinternational/terraform-modules//aws/ecs/service-only?ref=2.0.0"
  cluster_id         = "${var.ecs_cluster_id}"
  service_name       = "${var.idp_name}-${var.app_name}"
  service_env        = "${var.app_env}"
  container_def_json = "${data.template_file.task_def.rendered}"
  desired_count      = 1
  tg_arn             = "${aws_alb_target_group.idsync.arn}"
  lb_container_name  = "web"
  lb_container_port  = "80"
  ecsServiceRole_arn = "${var.ecsServiceRole_arn}"
}

/*
 * Create Cloudflare DNS record
 */
resource "cloudflare_record" "idsyncdns" {
  domain  = "${var.cloudflare_domain}"
  name    = "${var.subdomain}"
  value   = "${var.alb_dns_name}"
  type    = "CNAME"
  proxied = true
}
