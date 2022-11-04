#S3 bucket for thanos long term storage
resource "aws_s3_bucket" "thanos_bucket" {
  count = length(var.bucket_name) > 0 ? 1 : 0
  bucket = var.bucket_name[count.index]
  tags = {
    Name = "thanos-bucket"
  }
}

resource "aws_s3_bucket_acl" "thanos_bucket_acl" {
  bucket = aws_s3_bucket.thanos_bucket.id
  acl    = "private"
}