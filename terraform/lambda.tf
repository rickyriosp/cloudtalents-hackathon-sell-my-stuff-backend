# Existing S3 bucket with Lambda layer zip file
data "aws_s3_bucket" "lambda_bucket" {
  bucket = local.lambda_bucket
}

# IAM role for Lambda execution
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "sellmystuff_lambda" {
  name               = "lambda_execution_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# Common dependencies layer
resource "aws_lambda_layer_version" "sellmystuff_dependencies" {
  s3_bucket = data.aws_s3_bucket.lambda_bucket.id
  s3_key    = local.lambda_dependencies

  layer_name  = "sellmystuff_dependencies_layer"
  description = "Common dependencies for sellmystuff Lambda functions"

  compatible_runtimes      = [local.python_version]
  compatible_architectures = ["x86_64", "arm64"]
}

# Lambda function
resource "aws_lambda_function" "sellmystuff" {
  s3_bucket = data.aws_s3_bucket.lambda_bucket.id
  s3_key    = local.lambda_function

  function_name = "sellmystuff_lambda"
  role          = aws_iam_role.sellmystuff_lambda.arn
  handler       = "sell_my_stuff.lambda_handler.lambda_handler"

  layers = [aws_lambda_layer_version.sellmystuff_dependencies.arn]

  runtime = local.python_version
}

# Permission for API Gateway to invoke Lambda
resource "aws_lambda_permission" "api_gateway_sellmystuff" {
  statement_id  = "AllowSellMyStuffAPIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "sellmystuff_lambda"
  principal     = "apigateway.amazonaws.com"

  # The /* part allows invocation from any stage, method and resource path
  # within API Gateway.
  source_arn = "${aws_api_gateway_rest_api.sellmystuff.execution_arn}/*"
}