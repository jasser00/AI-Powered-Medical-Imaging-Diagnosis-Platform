resource "aws_wafv2_web_acl" "waf" {
  name        = "rate-sql-xss-based"
  description = "aws waf for cloudfont."
  scope       = "CLOUDFRONT"

  default_action {
    allow {}
  }
  rule {
    name     = "rule-1"
    priority = 1

    action {
      count {}
    }
    statement {

      sqli_match_statement {

        field_to_match {
          body {}
        }

        text_transformation {
          priority = 5
          type     = "URL_DECODE"
        }

        text_transformation {
          priority = 4
          type     = "HTML_ENTITY_DECODE"
        }

        text_transformation {
          priority = 3
          type     = "COMPRESS_WHITE_SPACE"
        }
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "rule-1"
      sampled_requests_enabled   = false
    }
  }

  rule {
    name     = "rule-2"
    priority = 2

    action {
      count {}
    }
    statement {

      xss_match_statement {

        field_to_match {
          method {}
        }

        text_transformation {
          priority = 2
          type     = "NONE"
        }
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "rule-2"
      sampled_requests_enabled   = false
    }
  }
  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "rule-2"
    sampled_requests_enabled   = false
  }

  tags = local.common

}
