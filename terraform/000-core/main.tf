/*
 * Create ECS cluster
 */
module "ecscluster" {
  source       = "github.com/silinternational/terraform-modules//aws/ecs/cluster?ref=8.13.2"
  cluster_name = var.cluster_name
}

/*
 * Create user for CI/CD to perform ECS actions
 */
resource "aws_iam_user" "cd" {
  count = var.create_cd_user ? 1 : 0

  name = "cd-${var.cluster_name}"
}

resource "aws_iam_access_key" "cduser" {
  count = var.create_cd_user ? 1 : 0

  user = aws_iam_user.cd[0].name
}

resource "aws_iam_user_policy" "cd_ecs" {
  count = var.create_cd_user ? 1 : 0

  name = "ECS-ECR"
  user = aws_iam_user.cd[0].name

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
resource "aws_acm_certificate" "idp" {
  count = var.create_acm_cert ? 1 : 0

  domain_name               = var.cert_domain
  subject_alternative_names = ["*.${var.cert_domain}"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "cloudflare_record" "idp-verification" {
  count = var.create_acm_cert ? 1 : 0

  name    = tolist(aws_acm_certificate.idp[0].domain_validation_options)[0].resource_record_name
  value   = tolist(aws_acm_certificate.idp[0].domain_validation_options)[0].resource_record_value
  type    = tolist(aws_acm_certificate.idp[0].domain_validation_options)[0].resource_record_type
  zone_id = data.cloudflare_zone.domain.id
  proxied = false
}

data "cloudflare_zone" "domain" {
  name = var.cert_domain
}

resource "aws_acm_certificate_validation" "idp" {
  count = var.create_acm_cert ? 1 : 0

  certificate_arn         = aws_acm_certificate.idp[0].arn
  validation_record_fqdns = [cloudflare_record.idp-verification[0].hostname]
}

resource "aws_appconfig_application" "this" {
  count = var.appconfig_app_name == "" ? 0 : 1

  name = var.appconfig_app_name
}

resource "aws_appconfig_environment" "this" {
  count = var.appconfig_app_name == "" ? 0 : 1

  name           = var.app_env
  application_id = one(aws_appconfig_application.this[*].id)
}
