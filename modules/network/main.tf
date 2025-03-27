# Criar a VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.environment}-${var.project_name}-vpc"
  }
}

# Criar subnets privadas
resource "aws_subnet" "private_subnets" {
  count = length(var.private_subnet_cidrs)

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.environment}-${var.project_name}-vpc-subnet-private${count.index + 1}-${var.availability_zones[count.index]}"
  }
}

# Criar subnets públicas para os NAT Gateways
resource "aws_subnet" "public_subnets" {
  count = length(var.public_subnet_cidrs)

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.environment}-${var.project_name}-vpc-subnet-public${count.index + 1}-${var.availability_zones[count.index]}"
  }
}

# Criar um Internet Gateway para a VPC
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.environment}-${var.project_name}-vpc-igw"
  }
}

# Criar 1 Elastic IP para cada NAT Gateway
resource "aws_eip" "nat_eip" {
  count = length(var.public_subnet_cidrs)
}

# Criar 1 NAT Gateway por zona
resource "aws_nat_gateway" "nat_gw" {
  count         = length(var.public_subnet_cidrs)
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = aws_subnet.public_subnets[count.index].id

  tags = {
    Name = "${var.environment}-${var.project_name}-vpc-nat-public${count.index + 1}-${var.availability_zones[count.index]}"
  }
}

# Criar Tabela de Roteamento Pública
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.environment}-${var.project_name}-vpc-rtb-public"
  }
}

# Associar as subnets públicas à Tabela de Roteamento Pública
resource "aws_route_table_association" "public_subnets" {
  count = length(var.public_subnet_cidrs)

  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public.id
}

# Criar Tabelas de Roteamento Privadas e associar aos NAT Gateways
resource "aws_route_table" "private" {
  count  = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw[count.index].id
  }

  tags = {
    Name = "${var.environment}-${var.project_name}-vpc-rtb-private${count.index + 1}-${var.availability_zones[count.index]}"
  }
}

# Associar o route table privado a subnet privada
resource "aws_route_table_association" "private_subnet_association" {
  count = length(var.private_subnet_cidrs)

  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = aws_route_table.private[*].id # Associa às tabelas de rotas privadas

  tags = {
    Name = "${var.environment}-${var.project_name}-vpce-s3"
  }
}
