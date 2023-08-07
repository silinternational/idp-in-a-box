output "idsync_url" {
  value = "${var.subdomain}.${var.cloudflare_domain}"
}

output "access_token_external" {
  value = random_id.access_token_external.hex
}

output "public_dns_value" {
  description = "The value to use for the 'public' DNS record, if creating it outside of this module."
  value       = cloudflare_record.idsyncdns_intermediate.hostname
}
