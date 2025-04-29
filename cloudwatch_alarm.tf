resource "aws_cloudwatch_metric_alarm" "cpu_high_alarm" {
  alarm_name          = "High-CPU-Alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 30
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "This metric monitors if CPU usage exceeds 70%."
  
  alarm_actions = [
    aws_autoscaling_policy.scale_out_policy.arn,
    aws_sns_topic.capstone_alarm_topic.arn
  ]

  dimensions = {
    InstanceId = aws_instance.capstone.id
  }
}
