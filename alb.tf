# Create a new Application Load Balancer (ALB)
resource "aws_lb" "capstone_alb" {
  name               = "capstone-alb"
  load_balancer_type = "application"
  subnets            = [
    aws_subnet.capstone_public.id,
    aws_subnet.capstone_public_2.id
  ]
  security_groups    = [aws_security_group.alb_sg.id]  #  SG only for ALB

  tags = {
    Name = "capstone-alb"
  }
}

# Create a Target Group for ALB to forward requests
resource "aws_lb_target_group" "capstone_target_group" {
  name     = "capstone-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.capstone.id

  health_check {
    path                = "/"       # Check root URL
    interval            = 30        # Check every 30 seconds
    timeout             = 5         # Timeout after 5 seconds
    healthy_threshold   = 2         # Mark healthy after 2 successes
    unhealthy_threshold = 2         # Mark unhealthy after 2 failures
    matcher             = "200"     # Expect HTTP 200 OK
  }
}

# ALB Listener to listen on HTTP (port 80) and forward to target group
resource "aws_lb_listener" "capstone_listener" {
  load_balancer_arn = aws_lb.capstone_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.capstone_target_group.arn
  }
}
