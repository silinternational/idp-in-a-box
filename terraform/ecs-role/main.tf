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
 * Create ECS role
 */
resource "aws_iam_role" "this" {
  name = var.name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ECSAssumeRole"
        Effect = "Allow"
        Principal = {
          Service = [
            "ecs-tasks.amazonaws.com",
          ]
        }
        Action = "sts:AssumeRole"
        Condition = {
          ArnLike = {
            "aws:SourceArn" = "arn:aws:ecs:${local.aws_region}:${local.aws_account}:*"
          }
          StringEquals = {
            "aws:SourceAccount" = local.aws_account
          }
        }
      }
    ]
  })
}
