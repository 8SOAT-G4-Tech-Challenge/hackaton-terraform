
output "api_gateway_id" {
  description = "ID do API Gateway"
  value       = aws_apigatewayv2_api.api_gateway.id
}

output "api_gateway_arn" {
  description = "ARN do API Gateway"
  value       = aws_apigatewayv2_api.api_gateway.arn
}

output "api_gateway_stage_url" {
  description = "URL do stage do API Gateway"
  value       = aws_apigatewayv2_stage.api_gateway_stage.invoke_url
}
