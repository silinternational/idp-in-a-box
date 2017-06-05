/*
 * IAM outputs
 */
output "cduser_access_key_id" {
  value = "${aws_iam_access_key.cduser.id}"
}
output "cduser_access_key_secret" {
  value = "${aws_iam_access_key.cduser.secret}"
}
output "cduser_arn" {
  value = "${aws_iam_user.cd.arn}"
}
output "cduser_username" {
  value = "${aws_iam_user.cd.name}"
}

/*
 * ECS cluster outputs
 */
output "ecs_ami_id" {
  value = "${module.ecscluster.ami_id}"
}
output "ecs_cluster_id" {
  value = "${module.ecscluster.ecs_cluster_id}"
}
output "ecs_cluster_name" {
  value = "${module.ecscluster.ecs_cluster_name}"
}
output "ecs_instance_profile_id" {
  value = "${module.ecscluster.ecs_instance_profile_id}"
}
output "ecsInstanceRole_arn" {
  value = "${module.ecscluster.ecsInstanceRole_arn}"
}
output "ecsServiceRole_arn" {
  value = "${module.ecscluster.ecsServiceRole_arn}"
}
