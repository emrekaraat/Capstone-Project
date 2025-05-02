# ----------------------------------------
# Launch Template for Auto Scaling EC2s
# ----------------------------------------
resource "aws_launch_template" "capstone_launch_template" {
  name_prefix   = "capstone-launch-template-"                   # Launch template is versioned and auto-named
  image_id      = var.ami_id                                    # AMI ID for Amazon Linux 2
  instance_type = var.instance_type                             # EC2 instance type (e.g., t3.micro)
  key_name      = var.key_name                                  # SSH key for manual access if needed

  # IAM profile is disabled due to Vocareum restrictions
  # iam_instance_profile {
  #   name = aws_iam_instance_profile.cloudwatch_agent_profile.name
  # }

  network_interfaces {
    associate_public_ip_address = false                         # EC2 will not get a public IP
    security_groups             = [aws_security_group.capstone_sg.id]  # SG that allows HTTP & SSH
    subnet_id                   = aws_subnet.capstone_private_1.id     # Launch in private subnet
  }

  user_data = base64encode(templatefile("${path.module}/user_data.sh.tpl", {
    db_root_password = var.db_root_password,
    db_user          = var.db_user,
    db_user_password = var.db_user_password,
    db_name          = var.db_name,
    db_host          = aws_db_instance.capstone_rds.endpoint     # Connect to RDS
  }))
}

# ----------------------------------------
# Auto Scaling Group Configuration
# ----------------------------------------
resource "aws_autoscaling_group" "capstone_asg" {
  name                      = "capstone-asg"
  max_size                  = 10                                # Max EC2s
  min_size                  = 1                                 # Min EC2s
  desired_capacity          = 1                                 # Initial EC2 count
  vpc_zone_identifier       = [aws_subnet.capstone_private_1.id, aws_subnet.capstone_private_2.id]  # Spread across AZs
  health_check_type         = "ELB"                             # Use ALB for health checking
  health_check_grace_period = 300                               # Wait 5 minutes before checking health

  launch_template {
    id      = aws_launch_template.capstone_launch_template.id
    version = "$Latest"                                         # Always use latest version
  }

  target_group_arns = [aws_lb_target_group.capstone_target_group.arn]  # Register with target group

  tag {
    key                 = "Name"
    value               = "capstone-auto-instance"              # Tag instances for easier identification
    propagate_at_launch = true
  }
}

# ----------------------------------------
# Auto Scaling Policy – Scale Out
# ----------------------------------------
resource "aws_autoscaling_policy" "scale_out_policy" {
  name                   = "capstone-scale-out"
  scaling_adjustment     = 1                                    # Add 1 EC2 when CPU exceeds threshold
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300                                  # Wait 5 minutes before scaling again
  autoscaling_group_name = aws_autoscaling_group.capstone_asg.name
}

# ----------------------------------------
# Auto Scaling Policy – Scale In
# ----------------------------------------
resource "aws_autoscaling_policy" "scale_in_policy" {
  name                   = "capstone-scale-in"
  scaling_adjustment     = -1                                   # Remove 1 EC2 when CPU drops
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.capstone_asg.name
}
