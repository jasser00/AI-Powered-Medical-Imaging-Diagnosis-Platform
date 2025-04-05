resource "aws_cloudwatch_metric_alarm" "sqs_queue_length" {
  alarm_name          = "sqs-high-queue-length"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "ApproximateNumberOfMessagesVisible"
  namespace           = "AWS/SQS"
  period              = "60"
  statistic           = "Average"
  threshold           = "50"
  alarm_description   = "Alarm when queue length exceeds threshold"
  alarm_actions       = [aws_autoscaling_policy.scale_up.arn]
  dimensions = {
    QueueName = module.sqs.queue_name
  }
}
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale-up-on-sqs"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = module.asg_spot_instances.autoscaling_group_name
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "scale-down-on-sqs"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = module.asg_spot_instances.autoscaling_group_name
}

resource "aws_cloudwatch_metric_alarm" "sqs_queue_empty" {
  alarm_name          = "sqs-low-queue-length"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "5"
  metric_name         = "ApproximateNumberOfMessagesVisible"
  namespace           = "AWS/SQS"
  period              = "60"
  statistic           = "Average"
  threshold           = "10"
  alarm_description   = "Alarm when queue is nearly empty"
  alarm_actions       = [aws_autoscaling_policy.scale_down.arn]
  dimensions = {
    QueueName = module.sqs.queue_name
  }
}
