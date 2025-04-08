output "hostname" {
  value = "${local.subdomain_with_region}.${var.cloudflare_domain}"
}

output "public_dns_value" {
  description = "The value to use for the 'public' DNS record, if creating it outside of this module."
  value       = cloudflare_record.brokerdns.hostname
}

output "db_idbroker_user" {
  value = var.mysql_user
}

output "access_token_pwmanager" {
  value = var.output_alternate_tokens ? random_id.access_token_pwmanager_b.hex : random_id.access_token_pwmanager.hex
}

output "access_token_search" {
  value = var.output_alternate_tokens ? random_id.access_token_search_b.hex : random_id.access_token_search.hex
}

output "access_token_ssp" {
  value = var.output_alternate_tokens ? random_id.access_token_ssp_b.hex : random_id.access_token_ssp.hex
}

output "access_token_idsync" {
  value = var.output_alternate_tokens ? random_id.access_token_idsync_b.hex : random_id.access_token_idsync.hex
}

output "help_center_url" {
  value = var.help_center_url
}

output "email_signature" {
  value = var.email_signature
}

output "support_email" {
  value = var.support_email
}

output "support_name" {
  value = var.support_name
}
