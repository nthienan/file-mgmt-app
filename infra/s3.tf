locals {
  s3_bucket = {
    name = var.s3_bucket_name != "" ? var.s3_bucket_name : local.name_prefix
  }
}

resource "aws_s3_bucket" "main" {
  bucket = local.s3_bucket.name

  tags = merge(local.tags, {
    Name = local.s3_bucket.name
  })
}

resource "aws_s3_bucket_server_side_encryption_configuration" "main" {
  bucket = aws_s3_bucket.main.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
    bucket_key_enabled = true
  }
}
