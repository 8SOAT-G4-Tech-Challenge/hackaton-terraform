data "aws_lambda_function" "create_user" {
  function_name = "cognito-create-user-lambda"
}

data "aws_lambda_function" "authentication" {
  function_name = "cognito-authentication-lambda"
}
