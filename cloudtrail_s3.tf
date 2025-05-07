# Create an S3 bucket for storing CloudTrail logs
resource "aws_s3_bucket" "cloudtrail_logs_bucket" {
  bucket = "capstone-cloudtrail-logs-${random_id.bucket_suffix.hex}"  # Unique bucket name with suffix
  acl    = "private"                                                   # Only the owner can access the bucket

  tags = {
    Name        = "capstone-cloudtrail-logs"                           # Tag for identification
    Environment = "dev"                                                # Environment tag (dev/test/prod)
  }
}

# Generate a random suffix to ensure the bucket name is globally unique
resource "random_id" "bucket_suffix" {
  byte_length = 4                                                      # 4 bytes → 8-character hex string
}

# Create a bucket policy to allow CloudTrail to write logs to the bucket
resource "aws_s3_bucket_policy" "cloudtrail_bucket_policy" {
  bucket = aws_s3_bucket.cloudtrail_logs_bucket.id                     # Apply policy to this bucket

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AWSCloudTrailAclCheck"                            # Statement ID
        Effect    = "Allow"                                            # Allow action
        Principal = {
          Service = "cloudtrail.amazonaws.com"                         # Only CloudTrail can do this
        }
        Action   = "s3:GetBucketAcl"                                   # CloudTrail checks bucket permissions
        Resource = aws_s3_bucket.cloudtrail_logs_bucket.arn            # Bucket ARN
      },
      {
        Sid       = "AWSCloudTrailWrite"                               # Statement ID
        Effect    = "Allow"                                            # Allow action
        Principal = {
          Service = "cloudtrail.amazonaws.com"                         # Only CloudTrail can write logs
        }
        Action   = "s3:PutObject"                                      # Allow log upload
        Resource = "${aws_s3_bucket.cloudtrail_logs_bucket.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"  # S3 path
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"               # CloudTrail must use this ACL
          }
        }
      }
    ]
  })
}

# Get AWS account ID for bucket policy
data "aws_caller_identity" "current" {}                                # Used for path in PutObject permission
