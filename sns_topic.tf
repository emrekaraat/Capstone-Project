# Create an SNS Topic for CloudWatch alarms
resource "aws_sns_topic" "capstone_alarm_topic" {
  name = "capstone-alarm-topic"
}

# Subscribe an email address to the SNS Topic
resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.capstone_alarm_topic.arn
  protocol  = "email"
  endpoint  = var.notification_email
}
