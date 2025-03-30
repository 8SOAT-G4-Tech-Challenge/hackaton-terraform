output "alb_sg_id" {
  value       = aws_security_group.alb_sg.id
  description = "ID do Security Group do Application Loab Balancer"
}

output "eks_sg_id" {
  value       = aws_security_group.eks_sg.id
  description = "ID do Security Group do EKS"
}

output "rds_sg_id" {
  value       = aws_security_group.rds_sg.id
  description = "ID do Security Group do RDS"
}
