/*
 * Create VPC
 */
module "vpc" {
  source    = "github.com/silinternational/terraform-modules//aws/vpc?ref=2.2.0"
  app_name  = "${var.app_name}"
  app_env   = "${var.app_env}"
  aws_zones = "${var.aws_zones}"
}

/*
 * Security group to limit traffic to Cloudflare IPs
 */
module "cloudflare-sg" {
  source = "github.com/silinternational/terraform-modules//aws/cloudflare-sg?ref=2.2.0"
  vpc_id = "${module.vpc.id}"
}

/*
 * Determine most recent ECS optimized AMI
 */
data "aws_ami" "ecs_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }
}

/*
 * Create auto-scaling group
 */
module "asg" {
  source                  = "github.com/silinternational/terraform-modules//aws/asg?ref=2.2.0"
  app_name                = "${var.app_name}"
  app_env                 = "${var.app_env}"
  aws_instance            = "${var.aws_instance}"
  private_subnet_ids      = ["${module.vpc.private_subnet_ids}"]
  default_sg_id           = "${module.vpc.vpc_default_sg_id}"
  ecs_instance_profile_id = "${var.ecs_instance_profile_id}"
  ecs_cluster_name        = "${var.ecs_cluster_name}"
  ami_id                  = "${data.aws_ami.ecs_ami.id}"
}

/*
 * Create ssl cert for use with listener
 */
resource "aws_acm_certificate" "wildcard" {
  domain_name       = "${var.cert_domain_name}"
  validation_method = "DNS"

  tags {
    app_name = "${var.app_name}"
    app_env  = "${var.app_env}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "cloudflare_record" "cert_validation_dns_record" {
  domain = "${var.cert_domain_name}"
  name   = "${aws_acm_certificate.wildcard.domain_validation_options.0.resource_record_name}"
  value  = "${aws_acm_certificate.wildcard.domain_validation_options.0.resource_record_value}"
  type   = "${aws_acm_certificate.wildcard.domain_validation_options.0.resource_record_type}"
}

resource "aws_acm_certificate_validation" "wildcard_cert_validation" {
  certificate_arn = "${aws_acm_certificate.wildcard.arn}"
  validation_record_fqdns = ["${cloudflare_record.cert_validation_dns_record.hostname}"]
}

/*
 * Create application load balancer for public access
 */
module "alb" {
  source          = "github.com/silinternational/terraform-modules//aws/alb?ref=2.2.0"
  app_name        = "${var.app_name}"
  app_env         = "${var.app_env}"
  internal        = "false"
  vpc_id          = "${module.vpc.id}"
  security_groups = ["${module.vpc.vpc_default_sg_id}", "${module.cloudflare-sg.id}"]
  subnets         = ["${module.vpc.public_subnet_ids}"]
  certificate_arn = "${aws_acm_certificate.wildcard.arn}"
}

/*
 * Create application load balancer for internal use
 */
module "internal_alb" {
  source          = "github.com/silinternational/terraform-modules//aws/alb?ref=2.2.0"
  alb_name        = "alb-${var.app_name}-${var.app_env}-int"
  app_name        = "${var.app_name}"
  app_env         = "${var.app_env}"
  internal        = "true"
  tg_name         = "tg-${var.app_name}-${var.app_env}-int-def"
  vpc_id          = "${module.vpc.id}"
  security_groups = ["${module.vpc.vpc_default_sg_id}"]
  subnets         = ["${module.vpc.private_subnet_ids}"]
  certificate_arn = "${aws_acm_certificate.wildcard.arn}"
}

/*
 * Create Logentries Logset
 */
resource "logentries_logset" "logset" {
  name = "${var.app_name}-${var.app_env}"
}

/*
 * Create CloudWatch Dashboard for services that will be in this cluster
 */
module "ecs-service-cloudwatch-dashboard" {
  source  = "silinternational/ecs-service-cloudwatch-dashboard/aws"
  version = "~> 1.0.0"

  cluster_name = "${var.ecs_cluster_name}"
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
  aws_region = "${var.aws_region}"
}
