variable "environment" {
  description = "Ambiente"
  type        = string
}

variable "project_name" {
  description = "Nome do projeto"
  type        = string
}

variable "pg_main_database" {
  description = "Nome do banco de dados Postgres"
  type        = string
}

variable "pg_main_username" {
  description = "Nome do usuário do banco Postgres"
  type        = string
}

variable "pg_main_password" {
  description = "Senha do banco Postgres"
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
