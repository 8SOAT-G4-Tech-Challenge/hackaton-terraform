terraform {
  backend "s3" {
    bucket  = "hackaton-g4-terraform-state"
    key     = "staging/terraform.tfstate" # Estado específico para DEV
    region  = "us-east-1"
    encrypt = true
  }
}
