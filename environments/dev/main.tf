module "s3" {
  source = "../../modules/s3"

  environment  = var.environment
  project_name = var.project_name
}

module "network" {
  source = "../../modules/network"

  environment  = var.environment
  project_name = var.project_name
  aws_region   = var.aws_region
}

module "security" {
  source = "../../modules/security"

  environment  = var.environment
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

module "api" {
  source = "../../modules/api"

  environment        = var.environment
  project_name       = var.project_name
  alb_sg_id          = module.security.alb_sg_id
  private_subnet_ids = module.network.private_subnet_ids
  alb_listener_arn   = module.balancer.alb_listener_arn
}

module "cognito" {
  source = "../../modules/cognito"

  environment         = var.environment
  project_name        = var.project_name
  admin_user_email    = var.admin_user_email
  admin_user_password = var.admin_user_password
}


module "eks" {
  source = "../../modules/eks"

  environment  = var.environment
  project_name = var.project_name
}
