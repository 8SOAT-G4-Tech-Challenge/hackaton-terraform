variable "environment" {
  description = "Ambiente"
  type        = string
  default     = "prod"
}

variable "aws_region" {
  description = "Região da AWS"
  type        = string
}

variable "project_name" {
  description = "Nome do projeto"
  type        = string
}
