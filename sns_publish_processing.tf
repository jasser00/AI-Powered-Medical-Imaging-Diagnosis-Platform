module "sns_topic_publish" {
  depends_on = [aws_s3_bucket.uploaded_documents, module.sqs]
  source     = "terraform-aws-modules/sns/aws"

  name                        = "sns_publish.fifo"
  fifo_topic                  = true
  content_based_deduplication = true

  topic_policy_statements = {
    pub = {
      actions = ["sns:Publish"]
      principals = [{
        type        = "AWS"
        identifiers = ["s3.amazonaws.com"]
      }]
      conditions = [{
        test     = "ArnLike"
        variable = "aws:SourceArn"
        values   = [aws_s3_bucket.uploaded_documents.arn]
      }]
    },

    sub = {
      actions = [
        "sns:Subscribe"
      ]

      principals = [{
        type        = "AWS"
        identifiers = ["*"]
      }]

      conditions = [{
        test     = "StringLike"
        variable = "sns:Endpoint"
        values   = [module.sqs.queue_arn, aws_lambda_function.insert_order.arn]
      }]
    }
  }

  subscriptions = {
    sqs = {
      protocol = "sqs"
      endpoint = module.sqs.queue_arn
    },
    lambda = {
      protocol = "lambda"
      endpoint = aws_lambda_function.insert_order.arn
    }
  }

  tags = local.common
}


