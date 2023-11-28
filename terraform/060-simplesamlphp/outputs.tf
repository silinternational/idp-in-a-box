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

output "public_dns_value" {
  description = "The value to use for the 'public' DNS record, if creating it outside of this module."
  value       = cloudflare_record.sspdns_intermediate.hostname
}
