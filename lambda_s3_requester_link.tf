resource "aws_lambda_function" "requester_s3" {
  function_name    = "http-api-handler"
  runtime          = "nodejs18.x"
  handler          = "index.handler"
  filename         = "lambda_s3.zip"
  source_code_hash = filebase64sha256("lambda_s3.zip")
  layers           = ["arn:aws:lambda:us-east-1:580247275435:layer:LambdaInsightsExtension:14"]
  role             = aws_iam_role.lambda_exec_s3.arn
}
resource "aws_iam_role" "lambda_exec_s3" {
  name = "lambda-exec-s3"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}
resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.requester_s3.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.healthcare.execution_arn}/*/*"
}
resource "aws_apigatewayv2_integration" "lambda_s3_requester" {
  api_id           = aws_apigatewayv2_api.healthcare.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.requester_s3.invoke_arn
}
resource "aws_apigatewayv2_route" "requester_s3_route" {
  api_id    = aws_apigatewayv2_api.healthcare.id
  route_key = "ANY /myapi/upload"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_s3_requester.id}"
}
resource "aws_iam_policy" "s3_presigned_url_policy" {
  name        = "test_policy"
  description = "My s3-presigned_url  policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:PutObject"
        ],
        "Resource" : [
          "arn:aws:s3:::reports-uploaded-jasser-pfa/*"
        ]
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "s3_presigned_url_policy" {
  role       = aws_iam_role.lambda_exec_s3.name
  policy_arn = aws_iam_policy.s3_presigned_url_policy.arn
}
resource "aws_iam_role_policy_attachment" "lambda_insights_4_policy" {
  role       = aws_iam_role.lambda_exec_s3.name
  policy_arn = aws_iam_policy.lambda_insights.arn
}

