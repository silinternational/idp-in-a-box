output "ui_bucket" {
  value = "${aws_s3_bucket.ui.arn}"
}

output "cloudfront_distribution_id" {
  value = "${aws_cloudfront_distribution.ui.id}"
}

output "ui_hostname" {
  value = "${cloudflare_record.uidns.hostname}"
}

output "api_hostname" {
  value = "${cloudflare_record.apidns.hostname}"
}

output "db_pwmanager_user" {
  value = "${var.mysql_user}"
}
