output "user_pool_id" {
  value       = aws_cognito_user_pool.cognito_user_pool.id
  description = "ID do Cognito User Pool"
}

output "user_pool_arn" {
  value       = aws_cognito_user_pool.cognito_user_pool.arn
  description = "ARN do Cognito User Pool"
}

output "admin_client_id" {
  value       = aws_cognito_user_pool_client.cognito_user_pool_client.id
  description = "ID do client para administradores"
}

output "domain_name" {
  value       = aws_cognito_user_pool_domain.subdomain.domain
  description = "Domínio do Cognito"
}
