/*
 * Create ECS cluster
 */
module "ecscluster" {
  source   = "github.com/silinternational/terraform-modules//aws/ecs/cluster?ref=1.1.3"
  app_name = "${var.app_name}"
  app_env  = "${var.app_env}"
}

/*
 * Create user for CI/CD to perform ECS actions
 */
resource "aws_iam_user" "cd" {
  name = "cd-${var.app_name}-${var.app_env}"
}

resource "aws_iam_access_key" "cduser" {
  user = "${aws_iam_user.cd.name}"
}

resource "aws_iam_user_policy" "cd_ecs" {
  name = "ECS-ECR"
  user = "${aws_iam_user.cd.name}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecs:DeregisterTaskDefinition",
        "ecs:DescribeServices",
        "ecs:DescribeTaskDefinition",
        "ecs:DescribeTasks",
        "ecs:ListTasks",
        "ecs:ListTaskDefinitions",
        "ecs:RegisterTaskDefinition",
        "ecs:StartTask",
        "ecs:StopTask",
        "ecs:UpdateService",
        "iam:PassRole"
      ],
      "Resource": "*"
    },
    {
        "Effect": "Allow",
        "Action": [
            "ecr:GetAuthorizationToken"
        ],
        "Resource": [
            "*"
        ]
    }
  ]
}
EOF
}

/*
 * Create CloudTrail resources
 */
resource "aws_s3_bucket" "cloudtrail" {
  bucket        = "${var.app_name}-${var.app_env}-cloudtrail"
  force_destroy = true

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::${var.app_name}-${var.app_env}-cloudtrail"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${var.app_name}-${var.app_env}-cloudtrail/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
POLICY
}

resource "aws_iam_user" "cloudtrail-s3" {
  name = "cloudtrail-s3-${var.app_name}-${var.app_env}"
}

resource "aws_iam_access_key" "cloudtrail-s3" {
  user = "${aws_iam_user.cloudtrail-s3.name}"
}

resource "aws_iam_user_policy" "cloudtrail-s3" {
  name = "ECS-ECR"
  user = "${aws_iam_user.cloudtrail-s3.name}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetBucketPolicy",
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Resource": [
          "${aws_s3_bucket.cloudtrail.arn}",
          "${aws_s3_bucket.cloudtrail.arn}/*"
      ]
    }
  ]
}
EOF
}

resource "aws_cloudtrail" "cloudtrail" {
  name                          = "${var.app_name}-${var.app_env}-cloudtrail"
  s3_bucket_name                = "${aws_s3_bucket.cloudtrail.id}"
  include_global_service_events = true
}