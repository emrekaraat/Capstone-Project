# Create an S3 bucket for storing CloudTrail logs
resource "aws_s3_bucket" "cloudtrail_logs_bucket" {
  bucket = "capstone-cloudtrail-logs-${random_id.bucket_suffix.hex}"  # Unique bucket name with suffix

  tags = {
    Name        = "capstone-cloudtrail-logs"    # Tag to identify the bucket
    Environment = "dev"                         # Environment (e.g., dev, test, prod)
  }
}

# Apply private ACL to the S3 bucket using a separate resource (modern method)
resource "aws_s3_bucket_acl" "cloudtrail_logs_bucket_acl" {
  bucket = aws_s3_bucket.cloudtrail_logs_bucket.id
  acl    = "private"                            # Only the bucket owner has access
}

# Generate a random suffix to ensure the bucket name is globally unique
resource "random_id" "bucket_suffix" {
  byte_length = 4                               # 4 bytes → 8-character hex string
}

# Create a bucket policy to allow CloudTrail to write logs to the bucket
resource "aws_s3_bucket_policy" "cloudtrail_bucket_policy" {
  bucket = aws_s3_bucket.cloudtrail_logs_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AWSCloudTrailAclCheck"
        Effect    = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:GetBucketAcl"
        Resource = aws_s3_bucket.cloudtrail_logs_bucket.arn
      },
      {
        Sid       = "AWSCloudTrailWrite"
        Effect    = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.cloudtrail_logs_bucket.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      }
    ]
  })
}

# Get AWS account ID for dynamic path generation in bucket policy
data "aws_caller_identity" "current" {}
