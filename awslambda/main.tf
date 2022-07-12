terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.22.0"
    }
  }
}

# locals {
#   # Common tags to be assigned to all resources
#   functions = [
#     "clients",
#     "studies",
#     "subjects",
#     "sites",
#     "visits",
#     "forms"
#   ]
# }

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  access_key = "test"
  secret_key = "test"
  s3_use_path_style = false
  skip_credentials_validation = true
  skip_metadata_api_check = true
  skip_requesting_account_id = true
  endpoints {
    apigateway = "http://localhost:4566"
    iam = "http://localhost:4566"
    s3 = "http://s3.localhost.localstack.cloud:4566"
    lambda = "http://localhost:4566"
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"
  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "lambda.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  }
EOF
}


resource "aws_api_gateway_rest_api" "api_gw" {
  name = "GraphQL Resolver API Gateway"
  description = "GraphQL Resolver API Gateway v1"
}

module "clients" {
  source= "./modules/lambda"
  function_name = "clients"
  api_gateway = aws_api_gateway_rest_api.api_gw
  iam_role = aws_iam_role.iam_for_lambda
}
module "studies" {
  source= "./modules/lambda"
  function_name = "studies"
  api_gateway = aws_api_gateway_rest_api.api_gw
  iam_role = aws_iam_role.iam_for_lambda
}
module "subjects" {
  source= "./modules/lambda"
  function_name = "subjects"
  api_gateway = aws_api_gateway_rest_api.api_gw
  iam_role = aws_iam_role.iam_for_lambda
}
module "sites" {
  source= "./modules/lambda"
  function_name = "sites"
  api_gateway = aws_api_gateway_rest_api.api_gw
  iam_role = aws_iam_role.iam_for_lambda
}
module "visits" {
  source= "./modules/lambda"
  function_name = "visits"
  api_gateway = aws_api_gateway_rest_api.api_gw
  iam_role = aws_iam_role.iam_for_lambda
}
module "forms" {
  source= "./modules/lambda"
  function_name = "forms"
  api_gateway = aws_api_gateway_rest_api.api_gw
  iam_role = aws_iam_role.iam_for_lambda
}

resource "aws_api_gateway_deployment" "apigw_deployment" {
  depends_on = [
    module.clients.gateway_integration,
    module.studies.gateway_integration,
    module.subjects.gateway_integration,
    module.sites.gateway_integration,
    module.visits.gateway_integration,
    module.forms.gateway_integration
  ]
  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  stage_name = "test"
}


output "base_url" {
  description = "Base URL for API Gateway stage."

  value = "http://localhost:4566/restapis/${aws_api_gateway_rest_api.api_gw.id}/${aws_api_gateway_deployment.apigw_deployment.stage_name}/_user_request_/{func_path}"
}