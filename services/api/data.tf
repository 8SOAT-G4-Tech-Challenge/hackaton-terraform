data "aws_db_instance" "main_pg_url" {
  db_instance_identifier = "${var.environment}-${var.project_name}-postgres"
}
