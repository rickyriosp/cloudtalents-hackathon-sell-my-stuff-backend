locals {
  region              = "us-east-1"
  python_version      = "python3.13"
  lambda_bucket       = "hackathon-sell-my-stuff-backend-asd7891"
  lambda_function     = "artifacts/lambda_package.zip"
  lambda_dependencies = "artifacts/dependencies.zip"
}

provider "aws" {
  region = local.region

  default_tags {
    tags = {
      Application = "hackathon-sell-my-stuff"
      Environment = "dev"
    }
  }
}