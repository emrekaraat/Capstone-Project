# --------------------------------------------------
# Launch Template for Auto Scaling EC2 Instances
# --------------------------------------------------
resource "aws_launch_template" "capstone_launch_template" {
  name_prefix   = "capstone-launch-template-"              # Template name with prefix
  image_id      = var.ami_id                               # AMI to use (Amazon Linux 2)
  instance_type = var.instance_type                        # Instance type (e.g., t3.micro)
  key_name      = var.key_name                             # SSH key for manual connection if needed

  network_interfaces {
    associate_public_ip_address = false                    # Launch into private subnet
    security_groups             = [aws_security_group.asg_sg.id]  # ✅ New SG for ASG EC2s
    subnet_id                   = aws_subnet.capstone_private_1.id # Primary subnet to launch into
  }

  user_data = base64encode(templatefile("${path.module}/user_data.sh.tpl", {
    db_root_password = var.db_root_password,               # RDS root password
    db_user          = var.db_user,                        # DB user for WordPress
    db_user_password = var.db_user_password,               # DB user password
    db_name          = var.db_name,                        # WordPress DB name
    db_host          = aws_db_instance.capstone_rds.endpoint  # RDS endpoint
  }))
}

# --------------------------------------------------
# Auto Scaling Group (ASG)
# --------------------------------------------------
resource "aws_autoscaling_group" "capstone_asg" {
  name                      = "capstone-asg"                                      # ASG name
  max_size                  = 4                                                   # Max EC2s
  min_size                  = 1                                                   # Min EC2s
  desired_capacity          = 1                                                   # Start with 1 EC2
  vpc_zone_identifier       = [aws_subnet.capstone_private_1.id, aws_subnet.capstone_private_2.id]  # Spread across AZs
  health_check_type         = "ELB"                                               # Use ALB for health check
  health_check_grace_period = 300                                                 # Wait time before marking unhealthy

  launch_template {
    id      = aws_launch_template.capstone_launch_template.id                     # Launch template to use
    version = "$Latest"                                                           # Always use latest version
  }

  target_group_arns = [aws_lb_target_group.capstone_target_group.arn]            # Register with ALB target group

  tag {
    key                 = "Name"
    value               = "capstone-auto-instance"                                # Tag for EC2s
    propagate_at_launch = true                                                    # Apply tag at launch
  }
}

# --------------------------------------------------
# Scale Out Policy – Add EC2
# --------------------------------------------------
resource "aws_autoscaling_policy" "scale_out_policy" {
  name                   = "capstone-scale-out"                                   # Policy name
  scaling_adjustment     = 1                                                      # Add 1 instance
  adjustment_type        = "ChangeInCapacity"                                     # Based on number of instances
  cooldown               = 300                                                    # Wait time between scaling events
  autoscaling_group_name = aws_autoscaling_group.capstone_asg.name               # Target ASG
}

# --------------------------------------------------
# Scale In Policy – Remove EC2
# --------------------------------------------------
resource "aws_autoscaling_policy" "scale_in_policy" {
  name                   = "capstone-scale-in"
  scaling_adjustment     = -1                                                     # Remove 1 instance
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.capstone_asg.name
}
