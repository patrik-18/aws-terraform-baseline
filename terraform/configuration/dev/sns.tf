# Create an SNS topic
resource "aws_sns_topic" "inspector_notifications" {
  name = "inspector-findings-topic"
}

# Subscribe your email to the SNS topic
resource "aws_sns_topic_subscription" "email_subscription_1" {
  topic_arn = aws_sns_topic.inspector_notifications.arn
  protocol  = "email"
  endpoint  = "surek@meliovit.com"
}

resource "aws_sns_topic_subscription" "email_subscription_2" {
  topic_arn = aws_sns_topic.inspector_notifications.arn
  protocol  = "email"
  endpoint  = "vesely@meliovit.com"
}

# Configure AWS Inspector to use the SNS topic
resource "aws_inspector_assessment_target" "inspector_target" {
  name        = "inspector-target-sns"
}

resource "aws_inspector_assessment_template" "inspector_template" {
  name        = "example-template"
  target_arn = aws_inspector_assessment_target.inspector_target.arn
  duration    = "3600"
  rules_package_arns = ["arn:aws:inspector:eu-central-1:537503971621:rulespackage/0-wNqHa8M9"]
  tags = {
    Name = "example"
  }
}

resource "aws_inspector_assessment_template" "notification" {
  name        = "example-template-notification"
  target_arn = aws_inspector_assessment_target.inspector_target.arn
  duration    = "3600"
  rules_package_arns = ["arn:aws:inspector:eu-central-1:537503971621:rulespackage/0-wNqHa8M9"]
  event_subscription {
    event     = "FINDING_REPORTED"
    topic_arn = aws_sns_topic.inspector_notifications.arn
  }
}

resource "aws_sns_topic_policy" "inspector_topic_policy" {
  arn = aws_sns_topic.inspector_notifications.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          AWS = "*"
        }
        Action    = "sns:Publish"
        Resource  = aws_sns_topic.inspector_notifications.arn
        Condition = {
          StringEquals = {
            "AWS:SourceAccount" = "279806070403"
          }
        }
      }
    ]
  })
}
