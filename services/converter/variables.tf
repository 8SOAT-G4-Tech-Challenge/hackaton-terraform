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
