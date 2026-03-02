locals {
  config_src_dir = "${path.module}/../../config/etc"
}

resource "aws_s3_bucket" "cmangos" {
  bucket = var.cmangos_bucket

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_public_access_block" "cmangos" {
  bucket                  = aws_s3_bucket.cmangos.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "cmangos" {
  bucket = aws_s3_bucket.cmangos.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "cmangos" {
  bucket = aws_s3_bucket.cmangos.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_object" "config_files" {
  for_each = fileset(local.config_src_dir, "*")

  bucket = aws_s3_bucket.cmangos.id
  key    = "configs/${var.config_version}/etc/${each.value}"
  source = "${local.config_src_dir}/${each.value}"

  etag                   = filemd5("${local.config_src_dir}/${each.value}")
  server_side_encryption = "AES256"
}
