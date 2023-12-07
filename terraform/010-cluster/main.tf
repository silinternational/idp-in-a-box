/*
 * Create VPC
 */
module "vpc" {
  source                                          = "github.com/silinternational/terraform-modules//aws/vpc?ref=develop"
  app_name                                        = var.app_name
  app_env                                         = var.app_env
  aws_zones                                       = var.aws_zones
  create_nat_gateway                              = var.create_nat_gateway
  private_subnet_cidr_blocks                      = var.private_subnet_cidr_blocks
  public_subnet_cidr_blocks                       = var.public_subnet_cidr_blocks
  vpc_cidr_block                                  = var.vpc_cidr_block
  create_transit_gateway_attachment               = var.create_transit_gateway_attachment
  transit_gateway_id                              = var.transit_gateway_id
  transit_gateway_default_route_table_association = var.transit_gateway_default_route_table_association
  transit_gateway_default_route_table_propagation = var.transit_gateway_default_route_table_propagation
}

/*
 * Security group to limit traffic to Cloudflare IPs
 */
module "cloudflare-sg" {
  source = "github.com/silinternational/terraform-modules//aws/cloudflare-sg?ref=8.6.0"
  vpc_id = module.vpc.id
}

/*
 * Determine most recent ECS optimized AMI
 */
data "aws_ami" "ecs_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }
}

/*
 * Create auto-scaling group
 */
module "asg" {
  source                  = "github.com/silinternational/terraform-modules//aws/asg?ref=8.6.0"
  app_name                = var.app_name
  app_env                 = var.app_env
  aws_instance            = var.aws_instance
  private_subnet_ids      = module.vpc.private_subnet_ids
  default_sg_id           = module.vpc.vpc_default_sg_id
  ecs_instance_profile_id = var.ecs_instance_profile_id
  ecs_cluster_name        = var.ecs_cluster_name
  ami_id                  = data.aws_ami.ecs_ami.id
  additional_user_data    = var.asg_additional_user_data
  tags                    = var.tags
}

/*
 * Get ssl cert for use with listener
 */
data "aws_acm_certificate" "wildcard" {
  domain = var.cert_domain_name
}

/*
 * Create application load balancer for public access
 */
module "alb" {
  source          = "github.com/silinternational/terraform-modules//aws/alb?ref=8.6.0"
  app_name        = var.app_name
  app_env         = var.app_env
  internal        = "false"
  vpc_id          = module.vpc.id
  security_groups = [module.vpc.vpc_default_sg_id, module.cloudflare-sg.id]
  subnets         = module.vpc.public_subnet_ids
  certificate_arn = data.aws_acm_certificate.wildcard.arn
}

/*
 * Create application load balancer for internal use
 */
module "internal_alb" {
  source          = "github.com/silinternational/terraform-modules//aws/alb?ref=8.6.0"
  alb_name        = "alb-${var.app_name}-${var.app_env}-int"
  app_name        = var.app_name
  app_env         = var.app_env
  internal        = "true"
  tg_name         = "tg-${var.app_name}-${var.app_env}-int-def"
  vpc_id          = module.vpc.id
  security_groups = [module.vpc.vpc_default_sg_id]
  subnets         = module.vpc.private_subnet_ids
  certificate_arn = data.aws_acm_certificate.wildcard.arn
}

/*
 * Create Cloudwatch log group
 */
resource "aws_cloudwatch_log_group" "logs" {
  name              = "idp-${var.idp_name}-${var.app_env}"
  retention_in_days = 30

  tags = {
    idp_name = var.idp_name
    app_env  = var.app_env
  }
}

/*
 * Create CloudWatch Dashboard for services that will be in this cluster
 */
module "ecs-service-cloudwatch-dashboard" {
  count = var.create_dashboard ? 1 : 0

  source  = "silinternational/ecs-service-cloudwatch-dashboard/aws"
  version = "~> 3.0.1"

  cluster_name   = var.ecs_cluster_name
  dashboard_name = "${var.app_name}-${var.app_env}"

  service_names = [
    "${var.idp_name}-db-backup",
    "${var.idp_name}-email-service-api",
    "${var.idp_name}-email-service-cron",
    "${var.idp_name}-id-broker",
    "${var.idp_name}-id-broker-cron",
    "${var.idp_name}-id-sync",
    "${var.idp_name}-phpmyadmin",
    "${var.idp_name}-pw-manager",
    "${var.idp_name}-simplesamlphp",
  ]
}

