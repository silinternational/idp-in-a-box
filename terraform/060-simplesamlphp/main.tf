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
resource "aws_alb_target_group" "ssp" {
  name                 = "${replace("tg-${var.idp_name}-${var.app_name}-${var.app_env}", "/(.{0,32})(.*)/", "$1")}"
  port                 = "80"
  protocol             = "HTTP"
  vpc_id               = "${var.vpc_id}"
  deregistration_delay = "30"

  health_check {
    path    = "/module.php/silauth/status.php"
    matcher = "200"
  }
}

/*
 * Create listener rule for hostname routing to new target group
 */
resource "aws_alb_listener_rule" "ssp" {
  listener_arn = "${var.alb_https_listener_arn}"
  priority     = "60"

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.ssp.arn}"
  }

  condition {
    field  = "host-header"
    values = ["${var.subdomain}.${var.cloudflare_domain}"]
  }
}

/*
 * Create ECS service
 */
resource "random_id" "admin_pass" {
  byte_length = 32
}

resource "random_id" "secretsalt" {
  byte_length = 32
}

data "template_file" "task_def" {
  template = "${file("${path.module}/task-definition.json")}"

  vars {
    memory                       = "${var.memory}"
    cpu                          = "${var.cpu}"
    admin_pass                   = "${random_id.admin_pass.hex}"
    base_url                     = "https://${var.subdomain}.${var.cloudflare_domain}/"
    docker_image                 = "${var.docker_image}"
    password_change_url          = "${var.password_change_url}"
    password_forgot_url          = "${var.password_forgot_url}"
    hub_mode                     = "${var.hub_mode}"
    id_broker_access_token       = "${var.id_broker_access_token}"
    id_broker_assert_valid_ip    = "${var.id_broker_assert_valid_ip}"
    id_broker_base_uri           = "${var.id_broker_base_uri}"
    id_broker_trusted_ip_ranges  = "${join(",", var.id_broker_trusted_ip_ranges)}"
    mfa_learn_more_url           = "${var.mfa_learn_more_url}"
    mfa_setup_url                = "${var.mfa_setup_url}"
    idp_domain_name              = "${var.subdomain}.${var.cloudflare_domain}"
    logentries_key               = "${logentries_log.log.token}"
    memcache_host1               = "${var.memcache_host1}"
    memcache_host2               = "${var.memcache_host2}"
    mysql_database               = "${var.db_name}"
    mysql_host                   = "${var.mysql_host}"
    mysql_password               = "${var.mysql_pass}"
    mysql_user                   = "${var.mysql_user}"
    profile_url                  = "${profile_url}"
    recaptcha_key                = "${var.recaptcha_key}"
    recaptcha_secret             = "${var.recaptcha_secret}"
    remember_me_secret           = "${var.remember_me_secret}"
    secret_salt                  = "${random_id.secretsalt.hex}"
    show_saml_errors             = "${var.show_saml_errors}"
    idp_name                     = "${var.idp_name}"
    idp_display_name             = "${var.idp_display_name}"
    theme_color_scheme           = "${var.theme_color_scheme}"
    trusted_ip_addresses         = "${join(",", var.trusted_ip_addresses)}"
    analytics_id                 = "${var.analytics_id}"
    delete_remember_me_on_logout = "${var.delete_remember_me_on_logout}"
  }
}

module "ecsservice" {
  source             = "github.com/silinternational/terraform-modules//aws/ecs/service-only?ref=2.2.0"
  cluster_id         = "${var.ecs_cluster_id}"
  service_name       = "${var.idp_name}-${var.app_name}"
  service_env        = "${var.app_env}"
  container_def_json = "${data.template_file.task_def.rendered}"
  desired_count      = "${var.desired_count}"
  tg_arn             = "${aws_alb_target_group.ssp.arn}"
  lb_container_name  = "web"
  lb_container_port  = "80"
  ecsServiceRole_arn = "${var.ecsServiceRole_arn}"
}

/*
 * Create Cloudflare DNS record
 */
resource "cloudflare_record" "sspdns" {
  domain  = "${var.cloudflare_domain}"
  name    = "${var.subdomain}"
  value   = "${var.alb_dns_name}"
  type    = "CNAME"
  proxied = true
}
