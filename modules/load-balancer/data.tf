data "aws_instances" "ec2" {
  filter {
    name   = "tag:eks:nodegroup-name"
    values = ["${var.environment}-${var.project_name}-node-group"]
  }
}
