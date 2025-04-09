# Criação do security group do Application Load Balancer
resource "aws_security_group" "alb_sg" {
  name        = "${var.environment}-${var.project_name}-alb-sg"
  description = "Security Group do Application Load Balancer"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-${var.project_name}-alb-sg"
  }
}

# Criação do security group do EKS
resource "aws_security_group" "eks_sg" {
  name        = "${var.environment}-${var.project_name}-eks-sg"
  description = "Security Group do EKS"
  vpc_id      = var.vpc_id

  ingress {
    description = "Porta HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Porta HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Porta Postgres"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Node Port Hackaton API"
    from_port   = 31333
    to_port     = 31333
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Porta Kubelet"
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    # NÃO deve existir em um caso REAL
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-${var.project_name}-eks-sg"
  }
}

# Criação do security group do RDS
resource "aws_security_group" "rds_sg" {
  name        = "${var.environment}-${var.project_name}-rds-sg"
  description = "Security Group do RDS"
  vpc_id      = var.vpc_id

  ingress {
    description = "Porta Postgres"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-${var.project_name}-eks-sg"
  }
}

# Permitir que o RDS no seu próprio grupo de segurança
# consiga se comunicar com o EKS no seu próprio grupo de segurança
resource "aws_security_group_rule" "eks_to_rds" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds_sg.id
  source_security_group_id = aws_security_group.eks_sg.id
}
