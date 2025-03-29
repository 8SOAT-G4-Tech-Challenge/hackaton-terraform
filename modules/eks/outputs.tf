output "eks_cluster_name" {
  description = "Nome do Cluster EKS"
  value       = aws_eks_cluster.eks_cluster.name
}

output "eks_cluster_endpoint" {
  description = "Endpoint do Cluster EKS"
  value       = aws_eks_cluster.eks_cluster.endpoint
}

output "eks_cluster_arn" {
  description = "ARN do Cluster EKS"
  value       = aws_eks_cluster.eks_cluster.arn
}

output "eks_cluster_certificate_authority" {
  description = "Certificado de Autoridade do Cluster EKS"
  value       = aws_eks_cluster.eks_cluster.certificate_authority[0].data
}
