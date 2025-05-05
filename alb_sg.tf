resource "aws_security_group" "alb_sg" {
  name        = "capstone-alb-sg"
  description = "Allow HTTP from anywhere for ALB"
  vpc_id      = aws_vpc.capstone.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTP from the internet
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "capstone-alb-sg"
  }
}
