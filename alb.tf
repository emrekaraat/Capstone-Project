# Create ALB
resource "aws_lb" "capstone_alb" {
  name               = "capstone-alb"
  load_balancer_type = "application"
  subnets            = [
    aws_subnet.capstone_public_1.id,
    aws_subnet.capstone_public_2.id
  ]
  security_groups    = [aws_security_group.capstone_sg.id]

  tags = {
    Name = "capstone-alb"
  }
}

# Create Target Group
resource "aws_lb_target_group" "capstone_target_group" {
  name     = "capstone-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.capstone.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

# Create Listener
resource "aws_lb_listener" "capstone_listener" {
  load_balancer_arn = aws_lb.capstone_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.capstone_target_group.arn
  }
}
