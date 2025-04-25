locals {
  aws_region = data.aws_region.current.name
}

/*
 * AWS data
 */

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
    sentry_dsn                = var.sentry_dsn
    service_mode              = var.service_mode
  })
}

module "backup_task" {
  source  = "silinternational/scheduled-ecs-task/aws"
  version = "~> 0.1"

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
  version = "~> 0.2.2"

  app_name               = var.idp_name
  app_env                = var.app_env
  source_arns            = [data.aws_db_instance.this.db_instance_arn]
  backup_schedule        = var.aws_backup_schedule
  notification_events    = var.aws_backup_notification_events
  sns_topic_name         = "${var.idp_name}-backup-vault-events"
  sns_email_subscription = var.backup_sns_email
  cold_storage_after     = 0
  delete_after           = var.delete_recovery_point_after_days
}

data "aws_db_instance" "this" {
  db_instance_identifier = "idp-${var.idp_name}-${var.app_env}"
}

/*
 * Synchronize S3 bucket to Backblaze B2
 */
module "sync_s3_to_b2" {
  source  = "silinternational/sync-s3-to-b2/aws"
  version = "0.1.1"

  app_name              = var.app_name
  app_env               = var.app_env
  b2_application_key_id = var.b2_application_key_id
  b2_application_key    = var.b2_application_key
  b2_bucket             = var.b2_bucket_name
  b2_path               = var.b2_path
  cpu                   = var.backup_b2_cpu
  ecs_cluster_id        = var.ecs_cluster_id
  log_group_name        = var.log_group_name
  memory                = var.backup_b2_memory
  schedule              = var.b2_sync_schedule
  s3_bucket_name        = aws_s3_bucket.backup.bucket
  s3_path               = var.s3_backup_path
  rclone_arguments      = var.rclone_arguments
}
