
output "api_hostname" {
  value = "${var.api_subdomain}.${var.cloudflare_domain}"
}

output "db_pwmanager_user" {
  value = var.mysql_user
}
