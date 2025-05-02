# ----------------------------------------
# Launch Template for Auto Scaling EC2s
# ----------------------------------------
resource "aws_launch_template" "capstone_launch_template" {
  name_prefix   = "capstone-launch-template-"                   # Automatically prefixed name for version control
  image_id      = var.ami_id                                    # AMI ID for EC2 instances (e.g., Amazon Linux 2)
  instance_type = var.instance_type                             # EC2 instance type (e.g., t3.micro)
  key_name      = var.key_name                                  # SSH key for EC2 access

  # IAM instance profile is disabled due to sandbox (Vocareum) IAM limitations
  # iam_instance_profile {
  #   name = aws_iam_instance_profile.cloudwatch_agent_profile.name
  # }

  network_interfaces {
    associate_public_ip_address = false                         # Launch into private subnet (no public IP)
    security_groups             = [aws_security_group.capstone_sg.id]  # Attach security group
    subnet_id                   = aws_subnet.capstone_private_1.id     # Primary subnet for launch
  }

  user_data = base64encode(templatefile("${path.module}/user_data.sh.tpl", {
    db_root_password = var.db_root_password,                    # Password for RDS root user
    db_user          = var.db_user,                             # DB username for WordPress
    db_user_password = var.db_user_password,                    # DB password for WordPress
    db_name          = var.db_name,                             # Database name
    db_host          = aws_db_instance.capstone_rds.endpoint    # Endpoint of the RDS instance
  }))
}

# ----------------------------------------
# Auto Scaling Group Configuration
# ----------------------------------------
resource "aws_autoscaling_group" "capstone_asg" {
  name                      = "capstone-asg"                                            # Name of ASG
  max_size                  = 5                                                        # Max number of EC2 instances
  min_size                  = 1                                                         # Minimum to keep running
  desired_capacity          = 1                                                         # Desired capacity at launch
  vpc_zone_identifier       = [aws_subnet.capstone_private_1.id, aws_subnet.capstone_private_2.id]  # Deploy across AZs
  health_check_type         = "ELB"                                                     # Use ELB/ALB for health checks
  health_check_grace_period = 300                                                       # Delay health check after launch

  launch_template {
    id      = aws_launch_template.capstone_launch_template.id                           # Use the launch template created above
    version = "$Latest"                                                                 # Always pick latest template version
  }

  target_group_arns = [aws_lb_target_group.capstone_target_group.arn]                  # Attach EC2s to target group

  tag {
    key                 = "Name"                                                        # Add a Name tag to the instances
    value               = "capstone-auto-instance"
    propagate_at_launch = true                                                          # Apply tag at launch
  }
}

# ----------------------------------------
# Auto Scaling Policy – Scale Out (Add EC2s)
# ----------------------------------------
resource "aws_autoscaling_policy" "scale_out_policy" {
  name                   = "capstone-scale-out"                                         # Name of the policy
  scaling_adjustment     = 1                                                            # Add 1 instance
  adjustment_type        = "ChangeInCapacity"                                           # Add/remove based on instance count
  cooldown               = 300                                                          # Wait 5 minutes before another scale
  autoscaling_group_name = aws_autoscaling_group.capstone_asg.name                      # Target ASG
}

# ----------------------------------------
# Auto Scaling Policy – Scale In (Remove EC2s)
# ----------------------------------------
resource "aws_autoscaling_policy" "scale_in_policy" {
  name                   = "capstone-scale-in"                                          # Name of the policy
  scaling_adjustment     = -1                                                           # Remove 1 instance
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.capstone_asg.name
}
