variable "environment" {
  description = "Ambiente"
  type        = string
}

variable "project_name" {
  description = "Nome do projeto"
  type        = string
}

variable "aws_account_id" {
  description = "ID da conta da AWS"
  type        = string
}

variable "eks_sg_id" {
  description = "ID do Security Group do EKS"
  type        = string
}

variable "private_subnet_ids" {
  description = "ID das subnets privadas"
  type        = list(string)
}
