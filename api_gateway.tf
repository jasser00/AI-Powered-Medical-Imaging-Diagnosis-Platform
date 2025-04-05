resource "aws_apigatewayv2_api" "healthcare" {
  name          = "healthcare"
  protocol_type = "HTTP"
  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["GET", "POST", "PUT", "DELETE"]
    allow_headers = ["*"]
  }
}
resource "aws_apigatewayv2_stage" "healthcare" {
  api_id      = aws_apigatewayv2_api.healthcare.id
  name        = "$default"
  auto_deploy = true
}

output "api_endpoint" {
  value = aws_apigatewayv2_api.healthcare.api_endpoint
}
