output "hostname" {
  value = "${var.subdomain}.${var.cloudflare_domain}"
}

output "db_ssp_user" {
  value = var.mysql_user
}

output "admin_pass" {
  value = random_id.admin_pass.hex
}

output "secret_salt" {
  value     = local.secret_salt
  sensitive = true
}

