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


module "balancer" {
  source = "../../modules/balancer"

  environment        = var.environment
  project_name       = var.project_name
  aws_region         = var.aws_region
  vpc_id             = module.network.vpc_id
  alb_sg_id          = module.security.alb_sg_id
  private_subnet_ids = module.network.private_subnet_ids
}
