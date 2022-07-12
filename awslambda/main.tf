terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.22.0"
    }
  }
}

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

## Clients lambda
resource "aws_lambda_function" "clients_resolver_lambda" {
  filename = "resolvers/clients.zip"
  function_name = "clients_resolver_lambda"
  role = aws_iam_role.iam_for_lambda.arn
  handler = "clients.handler"
  source_code_hash = filebase64sha256("resolvers/clients.zip")
  runtime = "nodejs16.x"
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  parent_id = aws_api_gateway_rest_api.api_gw.root_resource_id
  path_part   = "graphql"
}

resource "aws_api_gateway_method" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  resource_id = aws_api_gateway_method.proxy.resource_id
  http_method = aws_api_gateway_method.proxy.http_method
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = aws_lambda_function.clients_resolver_lambda.invoke_arn
}
## End Clients Lambda

## Sites lambda
resource "aws_lambda_function" "sites_resolver_lambda" {
  filename = "resolvers/clients.zip"
  function_name = "sites_resolver_lambda"
  role = aws_iam_role.iam_for_lambda.arn
  handler = "clients.handler"
  source_code_hash = filebase64sha256("resolvers/clients.zip")
  runtime = "nodejs16.x"
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  parent_id = aws_api_gateway_rest_api.api_gw.root_resource_id
  path_part   = "graphql"
}

resource "aws_api_gateway_method" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  resource_id = aws_api_gateway_method.proxy.resource_id
  http_method = aws_api_gateway_method.proxy.http_method
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = aws_lambda_function.clients_resolver_lambda.invoke_arn
}
## End Sites Lambda

resource "aws_api_gateway_deployment" "apigw_deployment" {
  depends_on = [
    aws_api_gateway_integration.lambda,
  ]
  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  stage_name = "test"
}

resource "aws_lambda_permission" "apigw" {
  statement_id = "AllowAPIGatewayInvoke"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.clients_resolver_lambda.function_name
  principal = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.api_gw.execution_arn}/*/*"
}


output "base_url" {
  description = "Base URL for API Gateway stage."

  value = "http://localhost:4566/restapis/${aws_api_gateway_rest_api.api_gw.id}/${aws_api_gateway_deployment.apigw_deployment.stage_name}/_user_request_/${aws_api_gateway_resource.proxy.path_part}"
}
