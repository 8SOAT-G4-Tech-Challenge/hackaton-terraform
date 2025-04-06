data "aws_db_instance" "main_pg_url" {
  db_instance_identifier = "${var.environment}-${var.project_name}-postgres"
}

data "aws_lambda_function" "auth_lambda" {
  function_name = "cognito-get-user-lambda"
}


data "aws_sqs_queue" "converter_queue" {
  name = "${var.environment}-${var.project_name}-converter-queue"
}
