resource "aws_security_group" "capstone_rds_sg" {                 # Defines the SG for the RDS instance
  name        = "capstone-rds-sg"                                 # Name of the SG
  description = "Allow MySQL from Auto Scaling EC2"              # Description of allowed traffic
  vpc_id      = aws_vpc.capstone.id                              # Attach to the VPC named capstone

  ingress {
    description     = "Allow MySQL access from Auto Scaling EC2s" # Explain incoming rule
    from_port       = 3306                                        # MySQL default port
    to_port         = 3306
    protocol        = "tcp"                                       # TCP traffic
    security_groups = [aws_security_group.asg_sg.id]              # Allow only from EC2s in ASG SG
  }

  egress {
    from_port   = 0                                               # Allow all outbound ports
    to_port     = 0
    protocol    = "-1"                                            # All protocols
    cidr_blocks = ["0.0.0.0/0"]                                   # To anywhere
  }

  tags = {
    Name = "capstone-rds-sg"                                      # Add a Name tag for easier identification
  }
}
