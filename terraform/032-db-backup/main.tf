locals {
  aws_account = data.aws_caller_identity.this.account_id
  aws_region  = data.aws_region.current.name
}


/*
 * AWS data
 */

data "aws_caller_identity" "this" {}

data "aws_region" "current" {}


/*
 * Create S3 bucket for storing backups
 */
resource "aws_s3_bucket" "backup" {
  bucket        = "${var.idp_name}-${var.app_name}-${var.app_env}"
  force_destroy = true

  tags = {
    idp_name = var.idp_name
    app_name = var.app_name
    app_env  = var.app_env
  }
}

resource "aws_s3_bucket_acl" "backup" {
  bucket     = aws_s3_bucket.backup.id
  acl        = "private"
  depends_on = [aws_s3_bucket_ownership_controls.backup]
}

resource "aws_s3_bucket_ownership_controls" "backup" {
  bucket = aws_s3_bucket.backup.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "backup" {
  bucket = aws_s3_bucket.backup.id
  rule {
    id     = "delete-old-versions"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }
}

resource "aws_s3_bucket_versioning" "backup" {
  bucket = aws_s3_bucket.backup.id
  versioning_configuration {
    status = "Enabled"
  }
}

/*
 * Create user for putting backup files into the bucket
 */
resource "aws_iam_user" "backup" {
  name = var.backup_user_name == null ? "db-backup-${var.idp_name}-${var.app_env}" : var.backup_user_name
}

resource "aws_iam_access_key" "backup" {
  user = aws_iam_user.backup.name
}

resource "aws_iam_user_policy" "backup" {
  name = "S3-DB-Backup"
  user = aws_iam_user.backup.name

  policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "s3:PutObject",
          ]
          Resource = "${aws_s3_bucket.backup.arn}*"
        },
      ]
    }
  )
}

/*
 * Create ECS service
 */
locals {
  task_def_backup = templatefile("${path.module}/task-definition.json", {
    app_env                   = var.app_env
    app_name                  = var.app_name
    aws_region                = local.aws_region
    cloudwatch_log_group_name = var.cloudwatch_log_group_name
    aws_access_key            = aws_iam_access_key.backup.id
    aws_secret_key            = aws_iam_access_key.backup.secret
    cpu                       = var.cpu
    db_names                  = join(" ", var.db_names)
    docker_image              = var.docker_image
    mysql_host                = var.mysql_host
    mysql_pass                = var.mysql_pass
    mysql_user                = var.mysql_user
    memory                    = var.memory
    s3_bucket                 = aws_s3_bucket.backup.bucket
    service_mode              = var.service_mode
  })
}

module "backup_task" {
  source                 = "../task"
  name                   = "${var.idp_name}-${var.app_name}-${var.app_env}"
  event_rule_description = "Start scheduled backup"
  event_schedule         = local.event_schedule
  ecs_cluster_arn        = var.ecs_cluster_id
  task_definition_arn    = aws_ecs_task_definition.cron_td.arn
  tags = {
    app_name = var.app_name
    app_env  = var.app_env
  }
}

/*
 * Create cron task definition
 */
resource "aws_ecs_task_definition" "cron_td" {
  family                = "${var.idp_name}-${var.app_name}-${var.app_env}"
  container_definitions = local.task_def_backup
  network_mode          = "bridge"
}

locals {
  event_schedule = var.cron_schedule != "" ? var.cron_schedule : var.event_schedule
}

/*
 * AWS backup
 */
module "aws_backup" {
  count = var.enable_aws_backup ? 1 : 0

  source  = "silinternational/backup/aws"
  version = "0.2.0"

  app_name               = var.idp_name
  app_env                = var.app_env
  source_arns            = [data.aws_db_instance.this.db_instance_arn]
  backup_schedule        = var.aws_backup_schedule
  notification_events    = var.aws_backup_notification_events
  sns_topic_name         = "${var.idp_name}-backup-vault-events"
  sns_email_subscription = var.backup_sns_email
}

data "aws_db_instance" "this" {
  db_instance_identifier = "idp-${var.idp_name}-${var.app_env}"
}
