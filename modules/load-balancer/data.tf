data "aws_instances" "ec2" {
  filter {
    name   = "tag:Name"
    values = ["${var.environment}-${var.project_name}-eks-node-instance"]
  }
}
