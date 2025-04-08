data "aws_db_instance" "main_pg_url" {
  db_instance_identifier = "${var.environment}-${var.project_name}-postgres"
}

data "aws_sqs_queue" "converter_queue" {
  name = "${var.environment}-${var.project_name}-converter-queue"
}

data "aws_s3_bucket" "bucket" {
  bucket = "${var.environment}-${var.project_name}-g4-bucket"
}

data "aws_cognito_user_pools" "user_pools" {
  name = "${var.environment}-${var.project_name}-user-pool"
}

data "aws_iam_role" "labrole" {
  name = "LabRole"
}
