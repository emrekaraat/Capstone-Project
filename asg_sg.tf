# ----------------------------------------
# Security Group for Auto Scaling EC2s
# ----------------------------------------
resource "aws_security_group" "asg_sg" {
  name        = "asg-sg"
  description = "Security group for EC2 instances in Auto Scaling Group"
  vpc_id      = aws_vpc.capstone.id

  # Allow HTTP access from ALB (port 80)
  ingress {
    description      = "Allow HTTP from ALB"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups  = [aws_security_group.alb_sg.id]  # ALB’s SG ID
  }

  # Allow outbound internet access (for updates, packages, etc.)
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "asg-sg"
  }
}
