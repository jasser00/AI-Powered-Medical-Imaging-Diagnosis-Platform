resource "aws_cloudwatch_metric_alarm" "Requests" {
  depends_on                = [module.cloudfront]
  alarm_name                = "Requests-cloudfront"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 1
  metric_name               = "Requests"
  namespace                 = "AWS/CloudFront"
  period                    = 300
  statistic                 = "Sum"
  threshold                 = 10000
  alarm_description         = "This metric monitors cloudfront requests"
  insufficient_data_actions = []
  dimensions = {
    DistributionId = module.cloudfront.cloudfront_distribution_id
    Region         = "Global"
  }
  alarm_actions = [aws_sns_topic.cloudfront_security.arn]
}
resource "aws_cloudwatch_metric_alarm" "Bytes" {
  depends_on                = [module.cloudfront]
  alarm_name                = "Bytes-cloudfront"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 1
  metric_name               = "Bytes downloaded"
  namespace                 = "AWS/CloudFront"
  period                    = 60
  statistic                 = "Sum"
  threshold                 = 1000000000000
  alarm_description         = "This metric monitors cloudfront Bytes downloaded"
  insufficient_data_actions = []
  dimensions = {
    DistributionId = module.cloudfront.cloudfront_distribution_id
    Region         = "Global"
  }
  alarm_actions = [aws_sns_topic.cloudfront_security.arn]
}
resource "aws_sns_topic" "cloudfront_security" {
  name = "cloudfront-security"
}
resource "aws_sns_topic_subscription" "user_updates_sqs_target" {
  topic_arn = aws_sns_topic.cloudfront_security.arn
  protocol  = "email"
  endpoint  = "hasnijasser@gmail.com"
}
