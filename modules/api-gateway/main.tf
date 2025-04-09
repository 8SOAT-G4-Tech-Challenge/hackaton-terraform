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

# Criar stage
resource "aws_apigatewayv2_stage" "api_gateway_stage" {
  api_id      = aws_apigatewayv2_api.api_gateway.id
  name        = var.environment
  auto_deploy = true
}

# Rotas de criação de usuários
module "routes" {
  source = "./routes"

  api_id             = aws_apigatewayv2_api.api_gateway.id
  authorizer_id      = aws_apigatewayv2_authorizer.cognito.id
  alb_integration_id = aws_apigatewayv2_integration.alb_integration.id
  api_gateway_arn    = aws_apigatewayv2_api.api_gateway.execution_arn
}
