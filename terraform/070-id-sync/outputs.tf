output "idsync_url" {
  value = "${var.subdomain}.${var.cloudflare_domain}"
}

output "access_token_external" {
  value = random_id.access_token_external.hex
}
