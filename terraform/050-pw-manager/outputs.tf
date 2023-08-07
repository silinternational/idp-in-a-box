output "ui_bucket" {
  value = aws_s3_bucket.ui.arn
}

output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.ui[0].id
}

output "ui_hostname" {
  value = cloudflare_record.uidns.hostname
}

output "api_hostname" {
  value = "${var.api_subdomain}.${var.cloudflare_domain}"
}

output "db_pwmanager_user" {
  value = var.mysql_user
}

