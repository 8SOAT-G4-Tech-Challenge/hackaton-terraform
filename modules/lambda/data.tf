data "aws_iam_role" "labrole" {
  name = "LabRole"
}

data "aws_cognito_user_pools" "user_pools" {
  name = "${var.environment}-${var.project_name}-user-pool"
}

data "aws_secretsmanager_secret" "cognito_secret" {
  name = "cognito-client-id"
}

data "aws_secretsmanager_secret_version" "cognito_secret_value" {
  secret_id = data.aws_secretsmanager_secret.cognito_secret.id
}

data "archive_file" "auth_zip" {
  type        = "zip"
  source_dir  = "../../lambdas/authentication" # Diretório do código da Lambda
  output_path = "../../lambdas/authentication/lambda.zip"
}

data "archive_file" "get_user_zip" {
  type        = "zip"
  source_dir  = "../../lambdas/get-user" # Diretório do código da Lambda
  output_path = "../../lambdas/get-user/lambda.zip"
}

data "archive_file" "create_user_zip" {
  type        = "zip"
  source_dir  = "../../lambdas/create-user" # Diretório do código da Lambda
  output_path = "../../lambdas/create-user/lambda.zip"
}
