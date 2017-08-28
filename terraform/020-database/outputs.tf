output "rds_arn" {
  value = "${module.rds.arn}"
}

output "rds_address" {
  value = "${module.rds.address}"
}

output "mysql_user" {
  value = "${var.mysql_user}"
}

output "mysql_pass" {
  value = "${random_id.db_root_pass.hex}"
}

output "db_idbroker_pass" {
  value = "${random_id.db_idbroker_pass.hex}"
}

output "db_emailservice_pass" {
  value = "${random_id.db_emailservice_pass.hex}"
}

output "db_pwmanager_pass" {
  value = "${random_id.db_pwmanager_pass.hex}"
}

output "db_ssp_pass" {
  value = "${random_id.db_ssp_pass.hex}"
}
