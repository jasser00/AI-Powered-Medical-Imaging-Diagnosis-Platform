resource "aws_s3_bucket" "uploaded_documents" {
  bucket        = "reports-uploaded-jasser-pfa"
  force_destroy = true
  tags = {
    Name        = "Healthcare_bucket_uploads"
    Environment = "Dev"
  }
}
resource "aws_s3_bucket_versioning" "versioning_uploads" {
  bucket = aws_s3_bucket.uploaded_documents.id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_policy" "allow_access_from_lambda_and_vpc" {
  bucket = aws_s3_bucket.uploaded_documents.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "AllowLambdaAccess",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : aws_lambda_function.requester_s3.arn
        },
        "Action" : [
          "s3:PutObject"
        ],
        "Resource" : [
          "arn:aws:s3:::reports-uploaded-jasser-pfa",
          "arn:aws:s3:::reports-uploaded-jasser-pfa/*"
        ]
      },
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
resource "aws_s3_bucket_notification" "bucket_notification_uploads" {
  bucket = aws_s3_bucket.uploaded_documents.id

  topic {
    topic_arn = module.sns_topic_publish.topic_arn
    events    = ["s3:ObjectCreated:*"]
  }
}
