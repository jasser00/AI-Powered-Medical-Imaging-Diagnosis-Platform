module "dynamodb_table" {
  source = "terraform-aws-modules/dynamodb-table/aws"

  name                = "test_medical"
  hash_key            = "id"
  autoscaling_enabled = true
  attributes = [
    {
      name = "id"
      type = "N"
    }
  ]
  resource_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      },
      "Action": [
        "dynamodb:GetItem",
        "dynamodb:DescribeTable"
      ],
      "Resource": "${module.dynamodb_table.dynamodb_table_arn}",
      "Condition": {
        "StringLike": {
          "aws:PrincipalArn": [
            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/*Lambda*",
            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/*lambda*",
            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/service-role/*Lambda*"
          ]
        }
      }
    }
  ]
}
POLICY
  tags            = local.common
}
data "aws_caller_identity" "current" {}
