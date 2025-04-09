variable "environment" {
  description = "Ambiente"
  type        = string
}

variable "project_name" {
  description = "Nome do projeto"
  type        = string
}

variable "aws_region" {
  description = "Região da AWS dentro do módulo"
  type        = string
}

variable "alb_sg_id" {
  description = "ID do Security Group do Load Balancer"
  type        = string
}

variable "private_subnet_ids" {
  description = "IDs das subnets privadas"
  type        = list(string)
}

variable "alb_listener_arn" {
  description = "ARN do Listener HTTP do Load Balancer"
  type        = string
}

