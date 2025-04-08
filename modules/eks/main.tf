# Criação do Cluster
resource "aws_eks_cluster" "eks_cluster" {
  name     = "${var.environment}-${var.project_name}-cluster"
  role_arn = data.aws_iam_role.labrole.arn

  vpc_config {
    subnet_ids              = var.private_subnet_ids
    security_group_ids      = [var.eks_sg_id]
    endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs     = ["0.0.0.0/0"]
  }

  access_config {
    authentication_mode = "API_AND_CONFIG_MAP"
  }
}

# Criação do Launch Template
resource "aws_launch_template" "launch_template" {
  name = "${var.environment}-${var.project_name}-launch-template"

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 50
    }
  }

  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }

  credit_specification {
    cpu_credits = "standard"
  }

  disable_api_stop        = true
  disable_api_termination = true

  instance_type = "m5.large"

  # Não sei se precisa
  # vpc_security_group_ids = [var.eks_sg_id]
  network_interfaces {
    security_groups             = [var.eks_sg_id]
    associate_public_ip_address = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.environment}-${var.project_name}-eks-node-instance"
    }
  }
}

# Criação do Node Group
resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "${var.environment}-${var.project_name}-node-group"
  node_role_arn   = data.aws_iam_role.labrole.arn

  subnet_ids = var.private_subnet_ids

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  launch_template {
    id      = aws_launch_template.launch_template.id
    version = aws_launch_template.launch_template.latest_version
  }
}

# Criação do access entry para vincular Role ao EKS
resource "aws_eks_access_entry" "eks_access_entry" {
  cluster_name      = aws_eks_cluster.eks_cluster.name
  principal_arn     = "arn:aws:iam::${var.aws_account_id}:role/voclabs"
  kubernetes_groups = ["${var.project_name}"]
  type              = "STANDARD"
}

# Vinculação da política de acesso do EKS a uma Role
resource "aws_eks_access_policy_association" "policy_association" {
  cluster_name  = aws_eks_cluster.eks_cluster.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = "arn:aws:iam::${var.aws_account_id}:role/voclabs"

  access_scope {
    type = "cluster"
  }
}
