# IAM policy for Bedrock access
data "aws_iam_policy_document" "bedrock_access" {
  statement {
    effect = "Allow"
    actions = [
      "bedrock:InvokeModel",
      "bedrock:InvokeModelWithResponseStream",
      "bedrock:ListFoundationModels"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "bedrock_access" {
  name   = "lambda_bedrock_access"
  policy = data.aws_iam_policy_document.bedrock_access.json
}

resource "aws_iam_role_policy_attachment" "lambda_bedrock" {
  role       = aws_iam_role.sellmystuff_lambda.name
  policy_arn = aws_iam_policy.bedrock_access.arn
}

data "aws_iam_policy_document" "cloudwatch_access" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "cloudwatch_access" {
  name   = "lambda_cloudwatch_access"
  policy = data.aws_iam_policy_document.cloudwatch_access.json
}

resource "aws_iam_role_policy_attachment" "lambda_cloudwatch" {
  role       = aws_iam_role.sellmystuff_lambda.name
  policy_arn = aws_iam_policy.cloudwatch_access.arn
}