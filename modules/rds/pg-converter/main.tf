# Criação do parameter group
resource "aws_db_parameter_group" "postgres_params" {
  family = "postgres16"
  name   = "postgres16-params"
}

# Criação do parameter group
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "${var.environment}-${var.project_name}-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "Private RDS Subnet Group"
  }
}

resource "aws_db_instance" "pg_converter" {
  allocated_storage    = 20
  engine               = "postgres"
  engine_version       = 16
  instance_class       = "db.t3.micro"
  db_name              = var.pg_converter_database
  username             = var.pg_converter_username
  password             = var.pg_converter_password
  parameter_group_name = aws_db_parameter_group.postgres_params.name
  port                 = "5432"
  storage_type         = "gp2"
  skip_final_snapshot  = true

  # Privado dentro da VPC
  identifier             = "${var.environment}-${var.project_name}-postgres"
  vpc_security_group_ids = [var.rds_sg_id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  publicly_accessible    = false

  tags = {
    Name = "${var.environment}-${var.project_name}-postgres"
    Iac  = true
  }
}
