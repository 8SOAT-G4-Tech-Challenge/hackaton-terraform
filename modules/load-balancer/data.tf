data "aws_instance" "ec2" {
  filter {
    name   = "tag:Name"
    values = ["${var.environment}-${var.project_name}-eks-node-instance"]
  }
}
