# IAM policy for Bedrock access
resource "aws_iam_policy" "bedrock_access" {
  name = "lambda_bedrock_access"
  policy = templatefile(
    "${path.module}/files/iam/lambda_bedrock_policy.json",
    {
      aws_lambda_arn = aws_lambda_function.sellmystuff.arn
    }
  )
}

resource "aws_iam_role_policy_attachment" "lambda_bedrock" {
  role       = aws_iam_role.sellmystuff_lambda.name
  policy_arn = aws_iam_policy.bedrock_access.arn
}

# IAM policy for CloudWatch Logs access
resource "aws_iam_policy" "cloudwatch_access" {
  name = "lambda_cloudwatch_access"
  policy = templatefile(
    "${path.module}/files/iam/lambda_logs_policy.json",
    {
      aws_lambda_arn = aws_lambda_function.sellmystuff.arn
    }
  )
}

resource "aws_iam_role_policy_attachment" "lambda_cloudwatch" {
  role       = aws_iam_role.sellmystuff_lambda.name
  policy_arn = aws_iam_policy.cloudwatch_access.arn
}