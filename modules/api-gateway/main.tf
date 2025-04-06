# Criação do API Gateway
resource "aws_apigatewayv2_api" "api_gateway" {
  name          = "${var.environment}-${var.project_name}-api"
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["GET", "POST", "PUT", "DELETE"]
    allow_headers = ["*"]
  }
}

# Criação do VPC Link
resource "aws_apigatewayv2_vpc_link" "vpc_link" {
  name               = "${var.environment}-${var.project_name}-vpc-link"
  security_group_ids = [var.alb_sg_id]
  subnet_ids         = var.private_subnet_ids
}

# Criação da integração com o Load Balancer 
resource "aws_apigatewayv2_integration" "alb_integration" {
  api_id           = aws_apigatewayv2_api.api_gateway.id
  description      = "Integração com o Load Balancer"
  integration_type = "HTTP_PROXY"
  integration_uri  = var.alb_listener_arn

  integration_method = "ANY"
  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.vpc_link.id

  request_parameters = {
    "overwrite:path" = "$request.path"
  }
}

# Criação do middleware de autenticação do cognito
resource "aws_apigatewayv2_authorizer" "cognito" {
  api_id           = aws_apigatewayv2_api.api_gateway.id
  authorizer_type  = "JWT"
  identity_sources = ["$request.header.Authorization"]
  name             = "cognito-authorizer"


  jwt_configuration {
    audience = [data.aws_secretsmanager_secret_version.cognito_secret_value.secret_string]
    issuer   = "https://cognito-idp.${var.aws_region}.amazonaws.com/${data.aws_cognito_user_pools.user_pools.ids[0]}"
  }
}

# Adicionar trigger a lambda de criação de usuário
resource "aws_lambda_permission" "create_user" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = data.aws_lambda_function.create_user.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api_gateway.execution_arn}/*/*"
}

# Criação da integração com a lambda de criação de usuário
resource "aws_apigatewayv2_integration" "create_user" {
  api_id           = aws_apigatewayv2_api.api_gateway.id
  integration_type = "AWS_PROXY"

  integration_uri        = data.aws_lambda_function.create_user.invoke_arn
  integration_method     = "POST"
  payload_format_version = "2.0"
}

# Criação da rota de criação de usuário integrada a Lambda
resource "aws_apigatewayv2_route" "create_user" {
  api_id    = aws_apigatewayv2_api.api_gateway.id
  route_key = "POST /user"
  target    = "integrations/${aws_apigatewayv2_integration.create_user.id}"
}

# Adicionar trigger a lambda de criação de autenticação
resource "aws_lambda_permission" "auth" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = data.aws_lambda_function.authentication.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api_gateway.execution_arn}/*/*"
}

# Criação da integração com a lambda de autenticação
resource "aws_apigatewayv2_integration" "auth" {
  api_id           = aws_apigatewayv2_api.api_gateway.id
  integration_type = "AWS_PROXY"

  integration_uri        = data.aws_lambda_function.authentication.invoke_arn
  integration_method     = "POST"
  payload_format_version = "2.0"
}

# Criação da rota de autenticação integrada a Lambda
resource "aws_apigatewayv2_route" "auth" {
  api_id    = aws_apigatewayv2_api.api_gateway.id
  route_key = "POST /auth"
  target    = "integrations/${aws_apigatewayv2_integration.auth.id}"
}

# Adicionar trigger a lambda de pegar info do usuário
resource "aws_lambda_permission" "get_user" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = data.aws_lambda_function.get_user.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api_gateway.execution_arn}/*/*"
}

# Criação da integração com a lambda de pegar info do usuário
resource "aws_apigatewayv2_integration" "get_user" {
  api_id           = aws_apigatewayv2_api.api_gateway.id
  integration_type = "AWS_PROXY"

  integration_uri        = data.aws_lambda_function.get_user.invoke_arn
  integration_method     = "POST"
  payload_format_version = "2.0"
}

# Criação da rota de pegar info do usuário integrada a Lambda
resource "aws_apigatewayv2_route" "get_user" {
  api_id    = aws_apigatewayv2_api.api_gateway.id
  route_key = "GET /user-data"

  target             = "integrations/${aws_apigatewayv2_integration.get_user.id}"
  authorizer_id      = aws_apigatewayv2_authorizer.cognito.id
  authorization_type = "JWT"
}

# TODO: Adicionar rota
# Criação da rota xxx integrada ao Load Balancer
resource "aws_apigatewayv2_route" "route_file" {
  api_id    = aws_apigatewayv2_api.api_gateway.id
  route_key = "ANY /file/{proxy+}"

  target = "integrations/${aws_apigatewayv2_integration.alb_integration.id}"
}

# Criar stage
resource "aws_apigatewayv2_stage" "api_gateway_stage" {
  api_id      = aws_apigatewayv2_api.api_gateway.id
  name        = var.environment
  auto_deploy = true
}

