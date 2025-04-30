# ----------------------------------------
# Launch Template for Auto Scaling EC2s
# ----------------------------------------
resource "aws_launch_template" "capstone_launch_template" {
  name_prefix   = "capstone-launch-template-"
  image_id      = var.ami_id                         # The base AMI to launch instances
  instance_type = var.instance_type                  # Instance type (e.g., t3.micro)
  key_name      = var.key_name                       # SSH key for EC2 access

  # IAM role needed by EC2 to send logs to CloudWatch
  iam_instance_profile {
    name = aws_iam_instance_profile.cloudwatch_agent_profile.name
  }

  network_interfaces {
    associate_public_ip_address = false              # Private instance (no public IP)
    security_groups             = [aws_security_group.capstone_sg.id]  # Apply the security group
    subnet_id                   = aws_subnet.capstone_private_1.id     # Subnet for initial interface
  }

  # WordPress installation script with RDS connection details
  user_data = base64encode(templatefile("${path.module}/user_data.sh.tpl", {
    db_root_password = var.db_root_password,
    db_user          = var.db_user,
    db_user_password = var.db_user_password,
    db_name          = var.db_name,
    db_host          = aws_db_instance.capstone_rds.endpoint
  }))
}

# ----------------------------------------
# Auto Scaling Group Configuration
# ----------------------------------------
resource "aws_autoscaling_group" "capstone_asg" {
  name                      = "capstone-asg"
  max_size                  = 10                         # Upper limit of EC2 instances
  min_size                  = 1                          # At least 1 instance running
  desired_capacity          = 1                          # Default instance count on start
  vpc_zone_identifier       = [aws_subnet.capstone_private_1.id, aws_subnet.capstone_private_2.id]  # Subnets to launch EC2s in
  health_check_type         = "ELB"                      # Use ELB health check instead of EC2 default
  health_check_grace_period = 300                        # Wait 5 minutes before evaluating health

  launch_template {
    id      = aws_launch_template.capstone_launch_template.id
    version = "$Latest"                                 # Always use latest template version
  }

  target_group_arns = [aws_lb_target_group.capstone_target_group.arn]  # Connect instances to the ALB

  # Add Name tag to instances launched by ASG
  tag {
    key                 = "Name"
    value               = "capstone-auto-instance"
    propagate_at_launch = true
  }
}

# ----------------------------------------
# Auto Scaling Policy – Scale Out
# ----------------------------------------
resource "aws_autoscaling_policy" "scale_out_policy" {
  name                   = "capstone-scale-out"
  scaling_adjustment     = 1                         # Add 1 instance
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300                       # 5 minutes cooldown before next scale
  autoscaling_group_name = aws_autoscaling_group.capstone_asg.name
}

# ----------------------------------------
# Auto Scaling Policy – Scale In
# ----------------------------------------
resource "aws_autoscaling_policy" "scale_in_policy" {
  name                   = "capstone-scale-in"
  scaling_adjustment     = -1                        # Remove 1 instance
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.capstone_asg.name
}
