# Adicionar trigger a lambda de criação de usuário
resource "aws_lambda_permission" "create_user" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = data.aws_lambda_function.create_user.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.api_gateway_arn}/*/*"
}

# Criação da integração com a lambda de criação de usuário
resource "aws_apigatewayv2_integration" "create_user" {
  api_id           = var.api_id
  integration_type = "AWS_PROXY"

  integration_uri        = data.aws_lambda_function.create_user.invoke_arn
  integration_method     = "POST"
  payload_format_version = "2.0"
}

# Criação da rota de criação de usuário integrada a Lambda
resource "aws_apigatewayv2_route" "create_user" {
  api_id    = var.api_id
  route_key = "POST /user"
  target    = "integrations/${aws_apigatewayv2_integration.create_user.id}"
}
