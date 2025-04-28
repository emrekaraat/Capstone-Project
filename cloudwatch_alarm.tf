resource "aws_cloudwatch_metric_alarm" "cpu_high_alarm" {
  alarm_name          = "High-CPU-Alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "This metric monitors if CPU usage exceeds 70%."
  alarm_actions       = [aws_sns_topic.capstone_alarm_topic.arn] # Trigger email notification via SNS
  dimensions = {
    InstanceId = aws_instance.capstone.id
  }
}
