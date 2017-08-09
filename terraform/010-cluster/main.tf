/*
 * Create VPC
 */
module "vpc" {
  source    = "github.com/silinternational/terraform-modules//aws/vpc?ref=1.0.0"
  app_name  = "${var.app_name}"
  app_env   = "${var.app_env}"
  aws_zones = "${var.aws_zones}"
}

/*
 * Security group to limit traffic to Cloudflare IPs
 */
module "cloudflare-sg" {
  source = "github.com/silinternational/terraform-modules//aws/cloudflare-sg?ref=1.0.0"
  vpc_id = "${module.vpc.id}"
}

/*
 * Create auto-scaling group
 */
module "asg" {
  source                  = "github.com/silinternational/terraform-modules//aws/asg?ref=1.0.0"
  app_name                = "${var.app_name}"
  app_env                 = "${var.app_env}"
  aws_instance            = "${var.aws_instance}"
  aws_zones               = "${var.aws_zones}"
  private_subnet_ids      = ["${module.vpc.private_subnet_ids}"]
  default_sg_id           = "${module.vpc.vpc_default_sg_id}"
  ecs_instance_profile_id = "${var.ecs_instance_profile_id}"
  ecs_cluster_name        = "${var.ecs_cluster_name}"
  ami_id                  = "${var.ecs_ami_id}"
}

/*
 * Get ssl cert for use with listener
 */
data "aws_acm_certificate" "wildcard" {
  domain = "${var.cert_domain_name}"
}

/*
 * Create application load balancer for public access
 */
module "alb" {
  source          = "github.com/silinternational/terraform-modules//aws/alb?ref=1.0.0"
  app_name        = "${var.app_name}"
  app_env         = "${var.app_env}"
  internal        = "false"
  vpc_id          = "${module.vpc.id}"
  security_groups = ["${module.vpc.vpc_default_sg_id}", "${module.cloudflare-sg.id}"]
  subnets         = ["${module.vpc.public_subnet_ids}"]
  certificate_arn = "${data.aws_acm_certificate.wildcard.arn}"
}

/*
 * Create application load balancer for internal use
 */
module "internal_alb" {
  source          = "github.com/silinternational/terraform-modules//aws/alb?ref=1.0.0"
  alb_name        = "alb-${var.app_name}-${var.app_env}-int"
  app_name        = "${var.app_name}"
  app_env         = "${var.app_env}"
  internal        = "true"
  tg_name         = "tg-${var.app_name}-${var.app_env}-int-def"
  vpc_id          = "${module.vpc.id}"
  security_groups = ["${module.vpc.vpc_default_sg_id}"]
  subnets         = ["${module.vpc.private_subnet_ids}"]
  certificate_arn = "${data.aws_acm_certificate.wildcard.arn}"
}

/*
 * Create Logentries Logset
 */
resource "logentries_logset" "logset" {
  name = "${var.app_name}-${var.app_env}"
}
