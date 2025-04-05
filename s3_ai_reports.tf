resource "aws_s3_bucket" "reports_generated" {
  bucket        = "reports-generated-jasser-pfa"
  force_destroy = true
  tags          = local.common
}
resource "aws_s3_bucket_versioning" "versioning_generated" {
  bucket = aws_s3_bucket.reports_generated.id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_policy" "allow_access_from_vpc" {
  bucket = aws_s3_bucket.reports_generated.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowVPCEndpointAccess"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action = "s3:*"
        Resource = [
          "arn:aws:s3:::reports-generated-jasser-pfa",
          "arn:aws:s3:::reports-generated-jasser-pfa/*"
        ]
        Condition = {
          StringEquals = {
            "aws:SourceVpc" = module.test_vpc.vpc_id
          }
        }
      }
    ]
  })
}
resource "aws_s3_bucket_notification" "generated_reports_bucket_notification" {
  bucket = aws_s3_bucket.reports_generated.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.update_order.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.reports_update_dynamo]
}
