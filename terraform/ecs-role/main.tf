locals {
  aws_account = data.aws_caller_identity.this.account_id
  aws_region  = data.aws_region.current.name
}

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

resource "aws_iam_role_policy" "this" {
  count = var.policy == "" ? 0 : 1

  name   = var.name
  role   = aws_iam_role.this.id
  policy = var.policy
}


/*
 * AWS data
 */

data "aws_caller_identity" "this" {}

data "aws_region" "current" {}
