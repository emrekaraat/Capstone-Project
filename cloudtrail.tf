# Create a CloudTrail to log management and data events
resource "aws_cloudtrail" "capstone_trail" {
  name                          = "capstone-trail"                                  # CloudTrail name
  s3_bucket_name                = aws_s3_bucket.cloudtrail_logs_bucket.bucket       # S3 bucket for logs
  include_global_service_events = true                                              # Include global AWS services (e.g., IAM)
  is_multi_region_trail         = true                                              # Capture events across all regions
  enable_log_file_validation    = true                                              # Ensure integrity of logs

  event_selector {
    read_write_type           = "All"                                               # Log both read and write events
    include_management_events = true                                                # Log control plane actions (e.g., create user)
  }

  tags = {
  Name        = "capstone-trail"   # Tag to identify the resource easily in AWS Console
  Environment = "dev"              # Indicates the deployment environment (e.g., dev, test, prod)
}
}
