/*
 * Create S3 bucket for storing backups
 */
resource "aws_s3_bucket" "backup" {
  bucket        = "${var.idp_name}-${var.app_name}-${var.app_env}"
  acl           = "private"
  force_destroy = true

  versioning {
    enabled = true
  }

  lifecycle_rule {
    id      = "delete-old-versions"
    enabled = true

    noncurrent_version_expiration {
      days = 30
    }
  }

  tags {
    idp_name = "${var.idp_name}"
    app_name = "${var.app_name}"
    app_env  = "${var.app_env}"
  }
}

/*
 * Create user for putting backup files into the bucket
 */
resource "aws_iam_user" "backup" {
  name = "db-backup-${var.idp_name}-${var.app_env}"
}

resource "aws_iam_access_key" "backup" {
  user = "${aws_iam_user.backup.name}"
}

resource "aws_iam_user_policy" "backup" {
  name = "S3-DB-Backup"
  user = "${aws_iam_user.backup.name}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject"
      ],
      "Resource": "${aws_s3_bucket.backup.arn}*"
    }
  ]
}
EOF
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
data "template_file" "task_def_backup" {
  template = "${file("${path.module}/task-definition.json")}"

  vars {
    app_env        = "${var.app_env}"
    app_name       = "${var.app_name}"
    aws_access_key = "${aws_iam_access_key.backup.id}"
    aws_secret_key = "${aws_iam_access_key.backup.secret}"
    cpu            = "${var.cpu}"
    cron_schedule  = "${var.cron_schedule}"
    db_names       = "${join(" ", var.db_names)}"
    docker_image   = "${var.docker_image}"
    idp_name       = "${var.idp_name}"
    logentries_key = "${logentries_log.log.token}"
    mysql_host     = "${var.mysql_host}"
    mysql_pass     = "${var.mysql_pass}"
    mysql_user     = "${var.mysql_user}"
    memory         = "${var.memory}"
    s3_bucket      = "${aws_s3_bucket.backup.bucket}"
    service_mode   = "${var.service_mode}"
  }
}

module "ecsservice" {
  source             = "github.com/silinternational/terraform-modules//aws/ecs/service-no-alb?ref=1.1.3"
  cluster_id         = "${var.ecs_cluster_id}"
  service_name       = "${var.idp_name}-${var.app_name}"
  service_env        = "${var.app_env}"
  container_def_json = "${data.template_file.task_def_backup.rendered}"
  desired_count      = 1
}
