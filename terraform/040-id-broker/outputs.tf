output "hostname" {
  value = "${var.subdomain}.${var.cloudflare_domain}"
}

output "db_idbroker_user" {
  value = var.mysql_user
}

output "access_token_pwmanager" {
  value = random_id.access_token_pwmanager.hex
}

output "access_token_search" {
  value = random_id.access_token_search.hex
}

output "access_token_ssp" {
  value = random_id.access_token_ssp.hex
}

output "access_token_idsync" {
  value = random_id.access_token_idsync.hex
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

