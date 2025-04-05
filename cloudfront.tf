module "cloudfront" {
  depends_on          = [aws_s3_bucket.healthcare_bucket, module.acm, aws_wafv2_web_acl.waf]
  source              = "terraform-aws-modules/cloudfront/aws"
  comment             = "healthcare CloudFront"
  enabled             = true
  price_class         = "PriceClass_All"
  retain_on_delete    = false
  wait_for_deployment = false
  web_acl_id          = aws_wafv2_web_acl.waf.id

  create_origin_access_control = true
  origin_access_control = {
    s3_oac = {
      description      = "CloudFront access to S3"
      origin_type      = "s3"
      signing_behavior = "always"
      signing_protocol = "sigv4"
    }
  }

  origin = {
    healthcare = {
      origin_id   = "myapi"
      domain_name = "${aws_apigatewayv2_api.healthcare.id}.execute-api.us-east-1.amazonaws.com"
      custom_origin_config = {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "match-viewer"
        origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
      }
    }

    s3_oac = {
      domain_name           = aws_s3_bucket.healthcare_bucket.bucket_regional_domain_name
      origin_access_control = "s3_oac"
      origin_id             = "s3-origin"
    }

  }
  default_cache_behavior = {
    target_origin_id       = "s3-origin"
    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    query_string           = true
  }
  ordered_cache_behavior = [
    {
      path_pattern           = "/static/*"
      target_origin_id       = "s3-origin"
      viewer_protocol_policy = "allow-all"
      min_ttl                = 0
      default_ttl            = 86400
      max_ttl                = 31536000
      allowed_methods        = ["GET"]
      cached_methods         = ["GET"]

    },
    {
      path_pattern           = "/api/*"
      target_origin_id       = "myapi"
      allowed_methods        = ["GET", "HEAD", "DELETE", "POST", "PUT", "OPTIONS"]
      viewer_protocol_policy = "allow-all"
      cached_methods         = ["GET", "HEAD"]
    }

  ]

  viewer_certificate = {
    acm_certificate_arn = module.acm.acm_certificate_arn
    ssl_support_method  = "sni-only"
  }
}
output "cloudfront_distribution_id" {
  description = "The identifier for the distribution."
  value       = module.cloudfront.cloudfront_distribution_id
}

output "cloudfront_distribution_arn" {
  description = "The ARN (Amazon Resource Name) for the distribution."
  value       = module.cloudfront.cloudfront_distribution_arn
}

