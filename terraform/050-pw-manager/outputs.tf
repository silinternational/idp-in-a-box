
output "api_hostname" {
  value = one(cloudflare_record.apidns[*].hostname)
}

output "db_pwmanager_user" {
  value = var.mysql_user
}
