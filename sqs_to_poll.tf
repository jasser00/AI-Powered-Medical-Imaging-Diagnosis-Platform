module "sqs" {
  source = "terraform-aws-modules/sqs/aws"

  name                       = "sqs_to_poll.fifo"
  fifo_queue                 = true
  visibility_timeout_seconds = 1500

  create_queue_policy = true
  queue_policy_statements = {
    sns = {
      sid     = "SNSPublish"
      actions = ["sqs:SendMessage"]

      principals = [
        {
          type        = "Service"
          identifiers = ["sns.amazonaws.com"]
        }
      ]

      conditions = [{
        test     = "ArnEquals"
        variable = "aws:SourceArn"
        values   = ["arn:aws:sns:*:*:*"]
      }]
    }
  }

  tags = {
    Environment = "dev"
  }
}
resource "aws_sqs_queue_policy" "final_policy" {
  queue_url = module.sqs.queue_url
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = { Service = "sns.amazonaws.com" },
        Action    = "sqs:SendMessage",
        Resource  = module.sqs.queue_arn,
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = module.sns_topic_publish.topic_arn
          }
        }
      }
    ]
  })
}
