resource "aws_lambda_function" "update_order" {
  function_name    = "http-api-handler"
  runtime          = "nodejs18.x"
  handler          = "index.handler"
  filename         = "lambda_update.zip"
  source_code_hash = filebase64sha256("lambda_update.zip")
  role             = aws_iam_role.lambda_update_dynamo.arn
  layers           = ["arn:aws:lambda:us-east-1:580247275435:layer:LambdaInsightsExtension:14"]
}
resource "aws_iam_role" "lambda_update_dynamo" {
  name = "lambda-update-order"

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
resource "aws_lambda_permission" "reports_update_dynamo" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.update_order.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.reports_generated.arn
}
resource "aws_iam_policy" "dynamo_update_policy" {
  name        = "insert_policy"
  description = "My update  policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "dynamodb:PutItem",
          "dynamodb:UpdateItem"
        ],
        "Resource" : [
          module.dynamodb_table.dynamodb_table_arn
        ]
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "dynamo_update_policy" {
  role       = aws_iam_role.lambda_update_dynamo.name
  policy_arn = aws_iam_policy.dynamo_update_policy.arn
}
resource "aws_iam_role_policy_attachment" "lambda_insights_1_policy" {
  role       = aws_iam_role.lambda_update_dynamo.name
  policy_arn = aws_iam_policy.lambda_insights.arn
}

