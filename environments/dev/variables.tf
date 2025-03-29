variable "environment" {
  description = "Ambiente"
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "Região da AWS"
  type        = string
}

variable "project_name" {
  description = "Nome do projeto"
  type        = string
}

variable "admin_user_email" {
  description = "Email do admin"
  type        = string
}

variable "admin_user_password" {
  description = "Senha do admin"
  type        = string
}

variable "aws_account_id" {
  description = "ID da conta da AWS"
  type        = string
}

