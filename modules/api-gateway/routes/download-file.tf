resource "aws_apigatewayv2_route" "download_file" {
  api_id    = var.api_id
  route_key = "GET /files/download/{proxy+}"

  target = "integrations/${var.alb_integration_id}"
}
