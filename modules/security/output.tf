output "alb_sg_id" {
  value       = aws_security_group.alb_sg.id
  description = "ID do Security Group do Application Loab Balancer"
}

output "alb_sg_name" {
  value       = aws_security_group.alb_sg.name
  description = "Nome do Security Group Application Loab Balancer"
}

output "alb_sg_vpc_id" {
  value       = aws_security_group.alb_sg.vpc_id
  description = "ID da VPC associada ao Security Group Application Loab Balancer"
}

output "eks_sg_id" {
  value       = aws_security_group.eks_sg.id
  description = "ID do Security Group do EKS"
}

output "eks_sg_name" {
  value       = aws_security_group.eks_sg.name
  description = "Nome do Security Group EKS"
}

output "eks_sg_vpc_id" {
  value       = aws_security_group.eks_sg.vpc_id
  description = "ID da VPC associada ao Security Group EKS"
}
