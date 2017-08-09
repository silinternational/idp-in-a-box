/*
 * VPC outputs
 */
output "aws_zones" {
  value = ["${module.vpc.aws_zones}"]
}

output "cloudflare_sg_id" {
  value = "${module.cloudflare-sg.id}"
}

output "db_subnet_group_name" {
  value = "${module.vpc.db_subnet_group_name}"
}

output "nat_gateway_ip" {
  value = "${module.vpc.nat_gateway_ip}"
}

output "private_subnet_ids" {
  value = ["${module.vpc.private_subnet_ids}"]
}

output "public_subnet_ids" {
  value = ["${module.vpc.public_subnet_ids}"]
}

output "vpc_default_sg_id" {
  value = "${module.vpc.vpc_default_sg_id}"
}

output "vpc_id" {
  value = "${module.vpc.id}"
}

output "public_subnet_cidr_blocks" {
  value = ["${module.vpc.public_subnet_cidr_blocks}"]
}

output "private_subnet_cidr_blocks" {
  value = ["${module.vpc.private_subnet_cidr_blocks}"]
}

/*
 * External application load balancer outputs
 */
output "alb_arn" {
  value = "${module.alb.arn}"
}

output "alb_default_tg_arn" {
  value = "${module.alb.default_tg_arn}"
}

output "alb_dns_name" {
  value = "${module.alb.dns_name}"
}

output "alb_https_listener_arn" {
  value = "${module.alb.https_listener_arn}"
}

output "alb_id" {
  value = "${module.alb.id}"
}

/*
 * Internal application load balancer outputs
 */
output "internal_alb_arn" {
  value = "${module.internal_alb.arn}"
}

output "internal_alb_default_tg_arn" {
  value = "${module.internal_alb.default_tg_arn}"
}

output "internal_alb_dns_name" {
  value = "${module.internal_alb.dns_name}"
}

output "internal_alb_https_listener_arn" {
  value = "${module.internal_alb.https_listener_arn}"
}

output "internal_alb_id" {
  value = "${module.internal_alb.id}"
}

/*
 * AWS Certificate manager output
 */
output "wildcard_cert_arn" {
  value = "${data.aws_acm_certificate.wildcard.arn}"
}

/*
 * Logentries outputs
 */
output "logentries_set_id" {
  value = "${logentries_logset.logset.id}"
}
