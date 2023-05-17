/*
 * Create ECS cluster
 */
module "ecscluster" {
  source       = "github.com/silinternational/terraform-modules//aws/ecs/cluster?ref=8.1.0"
  cluster_name = "${var.app_name}-${var.app_env}"
  providers = {
    aws = aws.primary
  }
}

/*
 * Create secondary ECS cluster
 */
module "ecscluster_secondary" {
  count = var.aws_region_secondary == "" ? 0 : 1

  source       = "github.com/silinternational/terraform-modules//aws/ecs/cluster?ref=8.1.0"
  cluster_name = "${var.app_name}-${var.app_env}-secondary"
  providers = {
    aws = aws.secondary
  }
}

/*
 * Create user for CI/CD to perform ECS actions
 */
resource "aws_iam_user" "cd" {
  name = "cd-${var.app_name}-${var.app_env}"
}

resource "aws_iam_access_key" "cduser" {
  user = aws_iam_user.cd.name
}

resource "aws_iam_user_policy" "cd_ecs" {
  name = "ECS-ECR"
  user = aws_iam_user.cd.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
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
          "iam:PassRole",
        ],
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
        ],
        Resource = "*"
      }
    ]
  })
}

/*
 * Create ACM certificate
 */
data "cloudflare_zones" "idp" {
  filter {
    name = var.cert_domain
  }
}
resource "aws_acm_certificate" "idp" {
  count                     = var.create_acm_cert ? 1 : 0
  domain_name               = var.cert_domain
  subject_alternative_names = ["*.${var.cert_domain}"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "cloudflare_record" "idp-verification" {
  count   = var.create_acm_cert ? 1 : 0
  name    = tolist(aws_acm_certificate.idp[0].domain_validation_options)[0].resource_record_name
  value   = tolist(aws_acm_certificate.idp[0].domain_validation_options)[0].resource_record_value
  type    = tolist(aws_acm_certificate.idp[0].domain_validation_options)[0].resource_record_type
  zone_id = data.cloudflare_zones.idp.zones[0].id
  proxied = false
}

resource "aws_acm_certificate_validation" "idp" {
  count                   = var.create_acm_cert ? 1 : 0
  certificate_arn         = aws_acm_certificate.idp[0].arn
  validation_record_fqdns = [cloudflare_record.idp-verification[0].hostname]
}
