variable "environment" {
  description = "Ambiente"
  type        = string
}

variable "project_name" {
  description = "Nome do projeto"
  type        = string
}

variable "api_url" {
  description = "Endpoint do MS Principal"
  type        = string
}

variable "converter_port" {
  description = "Porta do MS Converter"
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
