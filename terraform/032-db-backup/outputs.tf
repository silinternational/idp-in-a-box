output "cron_schedule" {
  value = "${var.cron_schedule}"
}

output "s3_bucket_name" {
  value = "${aws_s3_bucket.backup.bucket}"
}

output "s3_bucket_arn" {
  value = "${aws_s3_bucket.backup.arn}"
}
