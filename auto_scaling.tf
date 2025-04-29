# Launch Template for Auto Scaling
resource "aws_launch_template" "capstone_launch_template" {
  name_prefix   = "capstone-launch-template-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.capstone_sg.id]
    subnet_id                   = aws_subnet.capstone_private_1.id
  }

  user_data = base64encode(templatefile("${path.module}/user_data.sh.tpl", {
    db_root_password = var.db_root_password,
    db_user          = var.db_user,
    db_user_password = var.db_user_password,
    db_name          = var.db_name,
    db_host          = aws_db_instance.capstone_rds.endpoint
  }))
}

# Auto Scaling Group
resource "aws_autoscaling_group" "capstone_asg" {
  name                      = "capstone-asg"
  max_size                  = 3
  min_size                  = 1
  desired_capacity          = 1
  vpc_zone_identifier       = [aws_subnet.capstone_private_1.id, aws_subnet.capstone_private_2.id]
  health_check_type         = "ELB"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.capstone_launch_template.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.capstone_target_group.arn]

  tag {
    key                 = "Name"
    value               = "capstone-auto-instance"
    propagate_at_launch = true
  }
}

# Scale Out Policy (EC2 sayısını artırır)
resource "aws_autoscaling_policy" "scale_out_policy" {
  name                   = "capstone-scale-out"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.capstone_asg.name
}

# Scale In Policy (EC2 sayısını azaltır)
resource "aws_autoscaling_policy" "scale_in_policy" {
  name                   = "capstone-scale-in"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.capstone_asg.name
}
