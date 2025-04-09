# Create authentication lambda
resource "aws_lambda_function" "auth_lambda" {
  function_name = "cognito-authentication-lambda"
  role          = data.aws_iam_role.labrole.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"
  timeout       = 10
  filename      = data.archive_file.auth_zip.output_path

  environment {
    variables = {
      USER_POOL_ID = data.aws_cognito_user_pools.user_pools.ids[0]
      CLIENT_ID    = data.aws_secretsmanager_secret_version.cognito_secret_value.secret_string
    }
  }
}

# Create user data lambda
resource "aws_lambda_function" "create_user" {
  function_name = "cognito-create-user-lambda"
  role          = data.aws_iam_role.labrole.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"
  timeout       = 10
  filename      = data.archive_file.create_user_zip.output_path

  environment {
    variables = {
      USER_POOL_ID = data.aws_cognito_user_pools.user_pools.ids[0]
      CLIENT_ID    = data.aws_secretsmanager_secret_version.cognito_secret_value.secret_string
    }
  }
}
