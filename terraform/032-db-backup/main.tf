/*
 * Create S3 bucket for storing backups
 */
resource "aws_s3_bucket" "backup" {
  bucket        = "${var.idp_name}-${var.app_name}-${var.app_env}"
  force_destroy = true
  acl    = "private"

  tags = {
    idp_name = var.idp_name
    app_name = var.app_name
    app_env  = var.app_env
  }
}

resource "aws_s3_bucket_acl" "backup" {
  bucket = aws_s3_bucket.backup.id
  acl    = "private"
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
  name = "db-backup-${var.idp_name}-${var.app_env}"
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
    aws_region                = var.aws_region
    cloudwatch_log_group_name = var.cloudwatch_log_group_name
    aws_access_key            = aws_iam_access_key.backup.id
    aws_secret_key            = aws_iam_access_key.backup.secret
    cpu                       = var.cpu
    cron_schedule             = var.cron_schedule
    db_names                  = join(" ", var.db_names)
    docker_image              = var.docker_image
    idp_name                  = var.idp_name
    mysql_host                = var.mysql_host
    mysql_pass                = var.mysql_pass
    mysql_user                = var.mysql_user
    memory                    = var.memory
    s3_bucket                 = aws_s3_bucket.backup.bucket
    service_mode              = var.service_mode
  })
}

/*
 * Create role for scheduled running of cron task definitions.
 */
resource "aws_iam_role" "ecs_events" {
  name = "ecs_events-${var.idp_name}-${var.app_name}-${var.app_env}"

  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Sid    = ""
          Effect = "Allow"
          Principal = {
            Service = "events.amazonaws.com"
          },
          Action = "sts:AssumeRole"
        },
      ]
    }
  )
}

resource "aws_iam_role_policy" "ecs_events_run_task_with_any_role" {
  name = "ecs_events_run_task_with_any_role"
  role = aws_iam_role.ecs_events.id

  policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Effect   = "Allow"
          Action   = "iam:PassRole"
          Resource = "*"
        },
        {
          Effect   = "Allow"
          Action   = "ecs:RunTask"
          Resource = "${aws_ecs_task_definition.cron_td.arn_without_revision}:*"
        },
      ]
    }
  )
}

/*
 * Create cron task definition
 */
resource "aws_ecs_task_definition" "cron_td" {
  family                = "${var.idp_name}-${var.app_name}-${var.app_env}"
  container_definitions = local.task_def_backup
  network_mode          = "bridge"
}

/*
 * CloudWatch configuration to start scheduled backup.
 */
resource "aws_cloudwatch_event_rule" "event_rule" {
  name        = "${var.idp_name}-${var.app_name}-${var.app_env}"
  description = "Start scheduled backup"

  schedule_expression = var.cron_schedule

  tags = {
    app_name = var.app_name
    app_env  = var.app_env
  }
}

resource "aws_cloudwatch_event_target" "backup_event_target" {
  target_id = "${var.idp_name}-${var.app_name}-${var.app_env}"
  rule      = aws_cloudwatch_event_rule.event_rule.name
  arn       = var.ecs_cluster_id
  role_arn  = aws_iam_role.ecs_events.arn

  ecs_target {
    task_count          = 1
    launch_type         = "EC2"
    task_definition_arn = aws_ecs_task_definition.cron_td.arn
  }
}

