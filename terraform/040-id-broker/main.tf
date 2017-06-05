/*
 * Create internal application load balancer
 */
resource "aws_alb" "alb" {
  name            = "alb-${var.app_name}-${var.app_env}"
  internal        = true
  security_groups = ["${var.vpc_default_sg_id}"]
  subnets         = ["${var.private_subnet_ids}"]

  tags {
    Name = "alb-${var.app_name}-${var.app_env}"
    app_name = "${var.app_name}"
    app_env = "${var.app_env}"
  }
}

/*
 * Create target group for ALB
 */
resource "aws_alb_target_group" "broker" {
  name     = "tg-${var.app_name}-${var.app_env}"
  port     = "80"
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"

  health_check {
    path = "/site/status"
    matcher = "200,204"
  }
}

/*
 * Create listeners to connect ALB to target group
 */
resource "aws_alb_listener" "https" {
  load_balancer_arn = "${aws_alb.alb.arn}"
  port = "443"
  protocol = "HTTPS"
  ssl_policy = "${var.ssl_policy}"
  certificate_arn = "${var.wildcard_cert_arn}"

  default_action {
    target_group_arn = "${aws_alb_target_group.broker.arn}"
    type = "forward"
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
  name = "${var.app_name}"
  source = "token"
}

/*
 * Create ECS service
 */
data "template_file" "task_def" {
  template = "${file("${path.module}/task-definition.json")}"

  vars {
    api_access_keys = "${random_id.access_token_pwmanager.hex},${random_id.access_token_ssp.hex},${random_id.access_token_idsync.hex}"
    app_env = "${var.app_env}"
    idp_name = "${var.idp_name}"
    db_name = "${var.db_name}"
    docker_image = "${var.docker_image}"
    ldap_admin_password = "${var.ldap_admin_password}"
    ldap_admin_username = "${var.ldap_admin_username}"
    ldap_base_dn = "${var.ldap_base_dn}"
    ldap_domain_controllers = "${var.ldap_domain_controllers}"
    ldap_use_ssl = "${var.ldap_use_ssl}"
    ldap_use_tls = "${var.ldap_use_tls}"
    logentries_key = "${logentries_log.log.token}"
    mailer_usefiles = "${var.mailer_usefiles}"
    mailer_host = "${var.mailer_host}"
    mailer_username = "${var.mailer_username}"
    mailer_password = "${var.mailer_password}"
    notification_email = "${var.notification_email}"
    migrate_pw_from_ldap = "${var.migrate_pw_from_ldap}"
    mysql_host = "${var.mysql_host}"
    mysql_user = "${var.mysql_user}"
    mysql_pass = "${var.mysql_pass}"
  }
}

module "ecsservice" {
  source = "github.com/silinternational/terraform-modules//aws/ecs/service-only"
  cluster_id = "${var.ecs_cluster_id}"
  service_name = "${var.app_name}"
  service_env = "${var.app_env}"
  ecsServiceRole_arn = "${var.ecsServiceRole_arn}"
  container_def_json = "${data.template_file.task_def.rendered}"
  desired_count = "${var.ecs_desired_count}"
  tg_arn = "${aws_alb_target_group.broker.arn}"
  lb_container_name = "web"
  lb_container_port = "80"
}

/*
 * Create Cloudflare DNS record
 */
resource "cloudflare_record" "brokerdns" {
  domain = "${var.cloudflare_domain}"
  name   = "${var.subdomain}"
  value  = "${aws_alb.alb.dns_name}"
  type   = "CNAME"
  proxied = false
}