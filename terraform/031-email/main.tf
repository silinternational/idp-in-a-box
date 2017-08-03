/*
 * Create internal application load balancer
 */
resource "aws_alb" "alb" {
  name            = "alb-${var.idp_name}-${var.app_name}-${var.app_env}"
  internal        = true
  security_groups = ["${var.vpc_default_sg_id}"]
  subnets         = ["${var.private_subnet_ids}"]

  tags {
    Name     = "alb-${var.idp_name}-${var.app_name}-${var.app_env}"
    app_name = "${var.app_name}"
    app_env  = "${var.app_env}"
  }
}

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
 * Create listeners to connect ALB to target group
 */
resource "aws_alb_listener" "https" {
  load_balancer_arn = "${aws_alb.alb.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "${var.ssl_policy}"
  certificate_arn   = "${var.wildcard_cert_arn}"

  default_action {
    target_group_arn = "${aws_alb_target_group.broker.arn}"
    type             = "forward"
  }
}

/*
 * Generate access tokens for consuming apps
 */
resource "random_id" "access_token_pwmanager" {
  byte_length = 16
}

resource "random_id" "access_token_idbroker" {
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
    api_access_keys         = "${random_id.access_token_pwmanager.hex},${random_id.access_token_idbroker.hex},${random_id.access_token_idsync.hex}"
    app_env                 = "${var.app_env}"
    app_name                = "${var.app_name}"
    cpu                     = "${var.cpu}"
    db_name                 = "${var.db_name}"
    docker_image            = "${var.docker_image}"
    email_brand_color       = "${var.email_brand_color}"
    email_brand_logo        = "${var.email_brand_logo}"
    email_queue_batch_size  = "${var.email_queue_batch_size}"
    from_email              = "${var.from_email}"
    from_name               = "${var.from_name}"
    idp_name                = "${var.idp_name}"
    logentries_key          = "${logentries_log.log.token}"
    mailer_host             = "${var.mailer_host}"
    mailer_password         = "${var.mailer_password}"
    mailer_usefiles         = "${var.mailer_usefiles}"
    mailer_username         = "${var.mailer_username}"
    mysql_host              = "${var.mysql_host}"
    mysql_pass              = "${var.mysql_pass}"
    mysql_user              = "${var.mysql_user}"
    memory                  = "${var.memory}"
    notification_email      = "${var.notification_email}"
  }
}

module "ecsservice" {
  source             = "github.com/silinternational/terraform-modules//aws/ecs/service-only"
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
 * Create Cloudflare DNS record
 */
resource "cloudflare_record" "brokerdns" {
  domain  = "${var.cloudflare_domain}"
  name    = "${var.subdomain}"
  value   = "${aws_alb.alb.dns_name}"
  type    = "CNAME"
  proxied = false
}
