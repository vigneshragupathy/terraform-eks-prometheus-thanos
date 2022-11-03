#S3 bucket for thanos long term storage
resource "aws_s3_bucket" "thanos_bucket" {
  bucket = "thanos-bucket"
  acl    = "private"
  versioning {
    enabled = true
  }
  lifecycle_rule {
    id      = "thanos_bucket_lifecycle"
    enabled = true
    prefix  = ""
    tags = {
      Environment = "dev"
    }
    expiration {
      days = 30
    }
  }
}