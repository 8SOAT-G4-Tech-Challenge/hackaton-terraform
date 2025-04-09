# Adicionar trigger a lambda de criação de autenticação
resource "aws_lambda_permission" "auth" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = data.aws_lambda_function.authentication.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.api_gateway_arn}/*/*"
}

# Criação da integração com a lambda de autenticação
resource "aws_apigatewayv2_integration" "auth" {
  api_id           = var.api_id
  integration_type = "AWS_PROXY"

  integration_uri        = data.aws_lambda_function.authentication.invoke_arn
  integration_method     = "POST"
  payload_format_version = "2.0"
}

# Criação da rota de autenticação integrada a Lambda
resource "aws_apigatewayv2_route" "auth" {
  api_id    = var.api_id
  route_key = "POST /auth"
  target    = "integrations/${aws_apigatewayv2_integration.auth.id}"
}
