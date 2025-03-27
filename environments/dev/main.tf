module "network" {
  source = "../../modules/network"

  project_name = var.project_name
  aws_region   = var.aws_region
}

module "security" {
  source = "../../modules/security"

  project_name = var.project_name
  aws_region   = var.aws_region
  vpc_id       = module.network.vpc_id
}
