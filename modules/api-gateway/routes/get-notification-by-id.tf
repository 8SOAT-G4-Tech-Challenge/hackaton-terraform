resource "aws_apigatewayv2_route" "get_notification_by_id" {
  api_id    = var.api_id
  route_key = "GET /files/notification/{id}"

  target             = "integrations/${var.alb_integration_id}"
  authorizer_id      = var.authorizer_id
  authorization_type = "JWT"
}
