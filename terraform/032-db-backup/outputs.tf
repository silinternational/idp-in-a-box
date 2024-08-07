output "cron_schedule" {
  value = local.event_schedule
}

output "event_schedule" {
  value = local.event_schedule
}

output "s3_bucket_name" {
  value = aws_s3_bucket.backup.bucket
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.backup.arn
}
