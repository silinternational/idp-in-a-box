output "hostname" {
  value = "${cloudflare_record.brokerdns.hostname}"
}

output "db_idbroker_user" {
  value = "${var.mysql_user}"
}

output "access_token_pwmanager" {
  value = "${random_id.access_token_pwmanager.hex}"
}

output "access_token_idbroker" {
  value = "${random_id.access_token_idbroker.hex}"
}

output "access_token_idsync" {
  value = "${random_id.access_token_idsync.hex}"
}
