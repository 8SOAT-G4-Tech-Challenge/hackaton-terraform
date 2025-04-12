resource "aws_apigatewayv2_route" "delete_file" {
  api_id    = var.api_id
  route_key = "DELETE /files/{fileId}"

  target             = "integrations/${var.alb_integration_id}"
  authorizer_id      = var.authorizer_id
  authorization_type = "JWT"
}
