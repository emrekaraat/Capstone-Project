# IAM role for CloudWatch Agent
resource "aws_iam_role" "cloudwatch_agent_role" {
  name = "capstone-cloudwatch-agent-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach managed policy for CloudWatch Agent
resource "aws_iam_role_policy_attachment" "cloudwatch_agent_policy_attach" {
  role       = aws_iam_role.cloudwatch_agent_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# Create instance profile to attach to EC2
resource "aws_iam_instance_profile" "cloudwatch_agent_profile" {
  name = "capstone-instance-profile"
  role = aws_iam_role.cloudwatch_agent_role.name
}
