#output for s3_bucket_name
output "s3_bucket_name" {
  description = "S3 bucket name for thanos long term storage"
  value       = aws_s3_bucket.thanos_bucket.id
}