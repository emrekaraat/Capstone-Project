resource "aws_security_group" "capstone_rds_sg" {
  name        = "capstone-rds-sg"
  description = "Allow MySQL from private EC2"
  vpc_id      = aws_vpc.capstone.id

  ingress {
    description     = "MySQL from private EC2"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.capstone_sg.id]  # EC2'nin SG’si
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "capstone-rds-sg"
  }
}
