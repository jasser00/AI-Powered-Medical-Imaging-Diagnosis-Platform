resource "aws_lambda_function" "dynamo" {
  function_name    = "http-api-handler"
  runtime          = "nodejs18.x"
  handler          = "index.handler"
  filename         = "lambda_dynamo.zip"
  source_code_hash = filebase64sha256("lambda_dynamo.zip")
  layers           = ["arn:aws:lambda:us-east-1:580247275435:layer:LambdaInsightsExtension:14"]
  role             = aws_iam_role.lambda_exec_dynamo.arn
}
resource "aws_iam_role" "lambda_exec_dynamo" {
  name = "lambda-exec-funamo"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "dynamodb.amazonaws.com"
      }
    }]
  })
}
resource "aws_lambda_permission" "api_gateway_dynamo" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.dynamo.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.healthcare.execution_arn}/*/*"
}
resource "aws_apigatewayv2_integration" "lambda_dynamo" {
  api_id           = aws_apigatewayv2_api.healthcare.id
  integration_type = "AWS_PROXY"

  integration_uri = aws_lambda_function.dynamo.invoke_arn
}
resource "aws_apigatewayv2_route" "dynamo_route" {
  api_id    = aws_apigatewayv2_api.healthcare.id
  route_key = "ANY /{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_dynamo.id}"
}
resource "aws_iam_policy" "dynamo_policy" {
  name        = "test_policy"
  description = "My s3-presigned_url  policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "dynamodb:Query",
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem"
        ],
        "Resource" : [
          module.dynamodb_table.dynamodb_table_arn
        ]
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "dynamo_policy" {
  role       = aws_iam_role.lambda_exec_dynamo.name
  policy_arn = aws_iam_policy.dynamo_policy.arn
}
resource "aws_iam_role_policy_attachment" "lambda_insights_3_policy" {
  role       = aws_iam_role.lambda_exec_dynamo.name
  policy_arn = aws_iam_policy.lambda_insights.arn
}

