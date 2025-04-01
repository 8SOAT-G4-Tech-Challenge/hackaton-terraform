module "s3" {
  source = "../../modules/storage"

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
  source = "../../modules/load-balancer"

  environment        = var.environment
  project_name       = var.project_name
  aws_region         = var.aws_region
  vpc_id             = module.network.vpc_id
  alb_sg_id          = module.security.alb_sg_id
  private_subnet_ids = module.network.private_subnet_ids
}

module "api" {
  source = "../../modules/api-gateway"

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

module "rds" {
  source = "../../modules/rds/pg-main"

  environment        = var.environment
  project_name       = var.project_name
  rds_sg_id          = module.security.rds_sg_id
  private_subnet_ids = module.network.private_subnet_ids
  pg_main_database   = var.pg_main_database
  pg_main_username   = var.pg_main_username
  pg_main_password   = var.pg_main_password
}

module "eks" {
  source = "../../modules/eks"

  environment        = var.environment
  project_name       = var.project_name
  aws_account_id     = var.aws_account_id
  eks_sg_id          = module.security.eks_sg_id
  private_subnet_ids = module.network.private_subnet_ids
}

module "ms_converter" {
  source = "../../services/converter"

  environment  = var.environment
  project_name = var.project_name
  api_url      = "http://${var.environment}-${var.project_name}-main.${var.environment}-${var.project_name}-main-service.svc.cluster.local"

  depends_on = [module.rds]
}

module "ms_api" {
  source = "../../services/api"

  environment       = var.environment
  project_name      = var.project_name
  converter_api_url = "http://${var.environment}-${var.project_name}-converter.${var.environment}-${var.project_name}-converter-service.svc.cluster.local"

  depends_on = [module.rds]
}
