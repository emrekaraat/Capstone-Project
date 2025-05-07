# Create IAM role for CloudTrail
resource "aws_iam_role" "cloudtrail_role" {
  name = "cloudtrail-role"  # Role name

  assume_role_policy = jsonencode({         # Trust relationship: CloudTrail can assume this role
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach the AWS-managed CloudTrail policy to the role
resource "aws_iam_role_policy_attachment" "cloudtrail_attach" {
  role       = aws_iam_role.cloudtrail_role.name                            # Target IAM role
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCloudTrailFullAccess"  # AWS-managed policy
}
