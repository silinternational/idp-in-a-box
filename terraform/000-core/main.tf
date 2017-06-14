/*
 * Create ECS cluster
 */
module "ecscluster" {
  source = "github.com/silinternational/terraform-modules//aws/ecs/cluster"
  app_name = "${var.app_name}"
  app_env = "${var.app_env}"
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
        "ecs:*"
      ],
      "Resource": [
        "${module.ecscluster.ecs_cluster_id}"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ecs:DescribeServices"
      ],
      "Resource": [
        "*"
      ]
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
