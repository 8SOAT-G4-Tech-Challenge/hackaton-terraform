resource "aws_apigatewayv2_route" "upload_file" {
  api_id    = var.api_id
  route_key = "POST /files/upload"

  target             = "integrations/${var.alb_integration_id}"
  authorizer_id      = var.authorizer_id
  authorization_type = "JWT"
}
