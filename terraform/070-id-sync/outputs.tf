output "idsync_url" {
  value = cloudflare_record.idsyncdns.hostname
}

output "access_token_external" {
  value = random_id.access_token_external.hex
}

