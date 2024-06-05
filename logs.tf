resource "aws_cloudtrail" "main" {
  name                          = "main"
  s3_bucket_name                = aws_s3_bucket.trail_bucket.id
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true
}

resource "aws_cloudwatch_log_group" "trail_log_group" {
  name = "/aws/cloudtrail/main"
}

resource "aws_s3_bucket" "trail_bucket" {
  bucket = "my-trail-bucket"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "my_bucket_sse" {
  bucket = aws_s3_bucket.my_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm   = "aws:kms"
      kms_master_key_id = aws_kms_key.my_key.arn
    }
  }
}
