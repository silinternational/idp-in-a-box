/*
 * Create target group for ALB
 */
resource "aws_alb_target_group" "phpmyadmin" {
  name                 = "${replace("tg-${var.idp_name}-${var.app_name}-${var.app_env}", "/(.{0,32})(.*)/", "$1")}"
  port                 = "80"
  protocol             = "HTTP"
  vpc_id               = "${var.vpc_id}"
  deregistration_delay = "30"

  stickiness {
    type = "lb_cookie"
  }
}

/*
 * Create listener rule for hostname routing to new target group
 */
resource "aws_alb_listener_rule" "phpmyadmin" {
  listener_arn = "${var.alb_https_listener_arn}"
  priority     = "30"

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.phpmyadmin.arn}"
  }

  condition {
    field  = "host-header"
    values = ["${var.subdomain}.${var.cloudflare_domain}"]
  }
}

/*
 * Create ECS service
 */
data "template_file" "task_def" {
  template = "${file("${path.module}/task-definition.json")}"

  vars {
    hostname   = "${var.subdomain}.${var.cloudflare_domain}"
    mysql_host = "${var.rds_address}"
  }
}

module "ecsservice" {
  source             = "github.com/silinternational/terraform-modules//aws/ecs/service-only?ref=2.0.2"
  cluster_id         = "${var.ecs_cluster_id}"
  service_name       = "${var.idp_name}-${var.app_name}"
  service_env        = "${var.app_env}"
  container_def_json = "${data.template_file.task_def.rendered}"
  desired_count      = 1
  tg_arn             = "${aws_alb_target_group.phpmyadmin.arn}"
  lb_container_name  = "phpMyAdmin"
  lb_container_port  = "80"
  ecsServiceRole_arn = "${var.ecsServiceRole_arn}"
}

/*
 * Create Cloudflare DNS record
 */
resource "cloudflare_record" "pmadns" {
  domain  = "${var.cloudflare_domain}"
  name    = "${var.subdomain}"
  value   = "${var.alb_dns_name}"
  type    = "CNAME"
  proxied = true
}
