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

/*
 * Application load balancer outputs
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
output "wildcard_cert_arn" {
  value = "${data.aws_acm_certificate.wildcard.arn}"
}

/*
 * Logentries outputs
 */
output "logentries_set_id" {
  value = "${logentries_logset.logset.id}"
}
