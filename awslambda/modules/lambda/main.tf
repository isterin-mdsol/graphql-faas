terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.22.0"
    }
  }
}

resource "aws_lambda_function" "resolver_lambda" {
  filename = "resolvers/${var.function_name}.zip"
  function_name = "${var.function_name}_resolver_lambda"
  role = var.iam_role.arn
  handler = "${var.function_name}.handler"
  source_code_hash = filebase64sha256("resolvers/clients.zip")
  runtime = "nodejs16.x"
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = var.api_gateway.id
  parent_id = var.api_gateway.root_resource_id
  path_part   = "${var.function_name}"
}

resource "aws_api_gateway_method" "proxy" {
  rest_api_id = "${var.api_gateway.id}"
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_gtw_int" {
  rest_api_id = "${var.api_gateway.id}"
  resource_id = aws_api_gateway_method.proxy.resource_id
  http_method = aws_api_gateway_method.proxy.http_method
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = aws_lambda_function.resolver_lambda.invoke_arn
}

resource "aws_lambda_permission" "apigw" {
  statement_id = "AllowAPIGatewayInvoke"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.resolver_lambda.function_name
  principal = "apigateway.amazonaws.com"
  source_arn = "${var.api_gateway.execution_arn}/*/*"
}
