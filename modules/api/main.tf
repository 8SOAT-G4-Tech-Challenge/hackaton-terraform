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

