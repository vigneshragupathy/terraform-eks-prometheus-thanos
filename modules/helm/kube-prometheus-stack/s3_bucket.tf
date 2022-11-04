#S3 bucket for thanos long term storage
resource "aws_s3_bucket" "thanos_bucket" {
  bucket = var.bucket_name
  tags = {
    Name = "thanos-bucket"
  }
}

resource "aws_s3_bucket_acl" "thanos_bucket_acl" {
  bucket = aws_s3_bucket.thanos_bucket.id
  acl    = "private"
}