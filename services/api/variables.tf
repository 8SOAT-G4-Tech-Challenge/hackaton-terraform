variable "environment" {
  description = "Ambiente"
  type        = string
}

variable "project_name" {
  description = "Nome do projeto"
  type        = string
}

variable "api_port" {
  description = "Porta do MS Api"
  type        = string
}

variable "aws_region" {
  description = "Região da AWS"
  type        = string
}

variable "aws_access_key_id" {
  description = "Secret AWS"
  type        = string
}

variable "aws_secret_access_key" {
  description = "Secret AWS"
  type        = string
}

variable "aws_session_token" {
  description = "Secret AWS"
  type        = string
}

variable "vpc_id" {
  description = "ID da VPC"
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

variable "api_gateway_url" {
  description = "URL de invocação do api gateway"
  type        = string
}
