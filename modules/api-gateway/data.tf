data "aws_secretsmanager_secret" "cognito_secret" {
  name = "cognito-client-id"
}

data "aws_secretsmanager_secret_version" "cognito_secret_value" {
  secret_id = data.aws_secretsmanager_secret.cognito_secret.id
}

data "aws_cognito_user_pools" "user_pools" {
  name = "${var.environment}-${var.project_name}-user-pool"
}

data "aws_lambda_function" "create_user" {
  function_name = "cognito-create-user-lambda"
}

data "aws_lambda_function" "authentication" {
  function_name = "cognito-authentication-lambda"
}

data "aws_lambda_function" "get_user" {
  function_name = "cognito-get-user-lambda"
}
