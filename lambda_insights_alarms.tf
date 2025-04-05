resource "aws_iam_policy" "lambda_insights" {
  name        = "lambda_insights_policy"
  description = "lambda insights policy cloudwatch to attach to lambdas"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ],
        "Resource" : [
          "arn:aws:logs:*:*:log-group:/aws/lambda-insights:*",
          "arn:aws:logs:*:*:log-group:/aws/lambda/*:*"
        ]
      }
    ]
  })
}
resource "aws_cloudwatch_metric_alarm" "lambda_insights_alarm" {
  alarm_name          = "lambda-insights"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/LambdaInsights"
  period              = 120
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "This metric monitors lambda cpu utilization"
  alarm_actions       = [aws_sns_topic.cloudfront_security.arn]
}
