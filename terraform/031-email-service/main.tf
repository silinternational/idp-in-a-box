/*
 * Create target group for ALB
 */
resource "aws_alb_target_group" "email" {
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
resource "aws_alb_listener_rule" "email" {
  listener_arn = "${var.internal_alb_listener_arn}"
  priority     = "31"

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.email.arn}"
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

resource "random_id" "access_token_idbroker" {
  byte_length = 16
}

resource "random_id" "access_token_idsync" {
  byte_length = 16
}

/*
 * Create role for access to SES
 */
resource "aws_iam_role" "ses" {
  name = "ses-${var.idp_name}-${var.app_name}-${var.app_env}"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "Service": [
                    "ses.amazonaws.com",
                    "ecs-tasks.amazonaws.com"
                ]
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF

}

resource "aws_iam_role_policy" "ses" {
  name   = "ses"
  role   = "${aws_iam_role.ses.id}"
  policy = <<EOM
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "SendEmail",
      "Effect": "Allow",
      "Action":[
        "ses:SendEmail",
        "ses:SendRawEmail"
      ],
      "Resource": "*"
    }
  ]
}
EOM
}

/*
 * Create ECS services
 */
data "template_file" "task_def_api" {
  template = "${file("${path.module}/task-definition-api.json")}"

  vars {
    api_access_keys           = "${random_id.access_token_pwmanager.hex},${random_id.access_token_idbroker.hex},${random_id.access_token_idsync.hex}"
    app_env                   = "${var.app_env}"
    app_name                  = "${var.app_name}"
    aws_region                = "${var.aws_region}"
    cloudwatch_log_group_name = "${var.cloudwatch_log_group_name}"
    cpu_api                   = "${var.cpu_api}"
    db_name                   = "${var.db_name}"
    docker_image              = "${var.docker_image}"
    email_brand_color         = "${var.email_brand_color}"
    email_brand_logo          = "${var.email_brand_logo}"
    email_queue_batch_size    = "${var.email_queue_batch_size}"
    from_email                = "${var.from_email}"
    idp_name                  = "${var.idp_name}"
    mailer_usefiles           = "${var.mailer_usefiles}"
    mysql_host                = "${var.mysql_host}"
    mysql_pass                = "${var.mysql_pass}"
    mysql_user                = "${var.mysql_user}"
    memory_api                = "${var.memory_api}"
    notification_email        = "${var.notification_email}"
  }
}

module "ecsservice_api" {
  source             = "github.com/silinternational/terraform-modules//aws/ecs/service-only?ref=2.5.0"
  cluster_id         = "${var.ecs_cluster_id}"
  service_name       = "${var.idp_name}-${var.app_name}-api"
  service_env        = "${var.app_env}"
  ecsServiceRole_arn = "${var.ecsServiceRole_arn}"
  container_def_json = "${data.template_file.task_def_api.rendered}"
  desired_count      = "${var.desired_count_api}"
  tg_arn             = "${aws_alb_target_group.email.arn}"
  task_role_arn      = "${aws_iam_role.ses.arn}"
  lb_container_name  = "api"
  lb_container_port  = "80"
}

data "template_file" "task_def_cron" {
  template = "${file("${path.module}/task-definition-cron.json")}"

  vars {
    api_access_keys           = "${random_id.access_token_pwmanager.hex},${random_id.access_token_idbroker.hex},${random_id.access_token_idsync.hex}"
    app_env                   = "${var.app_env}"
    app_name                  = "${var.app_name}"
    aws_region                = "${var.aws_region}"
    cloudwatch_log_group_name = "${var.cloudwatch_log_group_name}"
    cpu_cron                  = "${var.cpu_cron}"
    db_name                   = "${var.db_name}"
    docker_image              = "${var.docker_image}"
    email_brand_color         = "${var.email_brand_color}"
    email_brand_logo          = "${var.email_brand_logo}"
    email_queue_batch_size    = "${var.email_queue_batch_size}"
    from_email                = "${var.from_email}"
    idp_name                  = "${var.idp_name}"
    mailer_usefiles           = "${var.mailer_usefiles}"
    mysql_host                = "${var.mysql_host}"
    mysql_pass                = "${var.mysql_pass}"
    mysql_user                = "${var.mysql_user}"
    memory_cron               = "${var.memory_cron}"
    notification_email        = "${var.notification_email}"
  }
}

module "ecsservice_cron" {
  source             = "github.com/silinternational/terraform-modules//aws/ecs/service-no-alb?ref=2.5.0"
  cluster_id         = "${var.ecs_cluster_id}"
  service_name       = "${var.idp_name}-${var.app_name}-cron"
  service_env        = "${var.app_env}"
  container_def_json = "${data.template_file.task_def_cron.rendered}"
  task_role_arn      = "${aws_iam_role.ses.arn}"
  desired_count      = 1
}

/*
 * Create Cloudflare DNS record
 */
resource "cloudflare_record" "emaildns" {
  domain  = "${var.cloudflare_domain}"
  name    = "${var.subdomain}"
  value   = "${var.internal_alb_dns_name}"
  type    = "CNAME"
  proxied = false
}
