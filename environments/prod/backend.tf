terraform {
  backend "s3" {
    bucket  = "prod-hackaton-g4-terraform-state"
    key     = "prod/terraform.tfstate" # Estado específico para DEV
    region  = "us-east-1"
    encrypt = true
  }
}
