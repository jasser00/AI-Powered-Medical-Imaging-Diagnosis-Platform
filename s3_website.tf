resource "aws_s3_bucket" "healthcare_bucket" {
  bucket        = "healthcare-web-pfa-project"
  force_destroy = true
  tags          = local.common
}
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.healthcare_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_policy" "allow_access_from_cloudfront" {
  bucket = aws_s3_bucket.healthcare_bucket.id
  policy = data.aws_iam_policy_document.allow_access_from_cloudfront.json
}
data "aws_iam_policy_document" "allow_access_from_cloudfront" {
  depends_on = [module.cloudfront]
  statement {
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.healthcare_bucket.arn}/*"]
    condition {
      test     = "StringEquals"
      values   = ["module.cloudfront.cloudfront_distribtuin_arn"]
      variable = "AWS:SourceArn"
    }
  }
}
