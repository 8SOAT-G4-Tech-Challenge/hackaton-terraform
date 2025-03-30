variable "environment" {
  description = "Ambiente"
  type        = string
}

variable "project_name" {
  description = "Nome do projeto"
  type        = string
}

variable "pg_converter_database" {
  description = "Nome do banco de dados Postgres do MS - Converter"
  type        = string
}

variable "pg_converter_username" {
  description = "Nome do usuário do banco Postgres do MS - Converter"
  type        = string
}

variable "pg_converter_password" {
  description = "Senha do banco Postgres do MS - Converter"
  type        = string
}

variable "rds_sg_id" {
  description = "ID do Security Group do RDS"
  type        = string
}

variable "private_subnet_ids" {
  description = "IDs das subnets privadas"
  type        = list(string)
}
