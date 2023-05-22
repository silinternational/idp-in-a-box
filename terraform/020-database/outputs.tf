output "rds_arn" {
  value = module.rds.arn
}

output "rds_address" {
  value = module.rds.address
}

output "mysql_user" {
  value = var.mysql_user
}

output "mysql_pass" {
  value     = local.root_pass
  sensitive = true
}

output "db_idbroker_pass" {
  value = local.idbroker_pass
}

output "db_emailservice_pass" {
  value = local.emailservice_pass
}

output "db_pwmanager_pass" {
  value = local.pwmanager_pass
}

output "db_ssp_pass" {
  value = local.ssp_pass
}

output "db_users_sql" {
  value = local.db_users_sql
}
