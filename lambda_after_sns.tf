resource "aws_lambda_function" "insert_order" {
  function_name    = "http-api-handler"
  runtime          = "nodejs18.x"
  handler          = "index.handler"
  filename         = "lambda_insert.zip"
  source_code_hash = filebase64sha256("lambda_insert.zip")
  layers           = ["arn:aws:lambda:us-east-1:580247275435:layer:LambdaInsightsExtension:14"]
  role             = aws_iam_role.lambda_insert_dynamo.arn
}
resource "aws_iam_role" "lambda_insert_dynamo" {
  name = "lambda-insert-order"

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
resource "aws_lambda_permission" "sns_insert_dynamo" {
  statement_id  = "AllowSNSInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.insert_order.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = module.sns_topic_publish.topic_arn
}
resource "aws_iam_policy" "dynamo_insert_policy" {
  name        = "insert_policy"
  description = "My insert  policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "dynamodb:PutItem"
        ],
        "Resource" : [
          module.dynamodb_table.dynamodb_table_arn
        ]
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "dynamo_insert_policy" {
  role       = aws_iam_role.lambda_insert_dynamo.name
  policy_arn = aws_iam_policy.dynamo_insert_policy.arn
}
resource "aws_iam_role_policy_attachment" "lambda_insights_2_policy" {
  role       = aws_iam_role.lambda_insert_dynamo.name
  policy_arn = aws_iam_policy.lambda_insights.arn
}

