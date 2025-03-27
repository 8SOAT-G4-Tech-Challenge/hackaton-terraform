output "vpc_id" {
  description = "ID da VPC criada"
  value       = aws_vpc.vpc.id
}

output "private_subnet_ids" {
  description = "IDs das subnets privadas"
  value       = aws_subnet.private_subnets[*].id
}

output "public_subnet_ids" {
  description = "IDs das subnets públicas"
  value       = aws_subnet.public_subnets[*].id
}

output "nat_gateway_ids" {
  description = "IDs dos NAT Gateways"
  value       = aws_nat_gateway.nat_gw[*].id
}
