provider "aws" {
  region = var.aws_region
}

# backend
terraform {
  backend "s3" {
    bucket = "terraform-999999999999"
    key    = "state/test_rony_ci/terraform.tfstate"
    region = "us-east-1"
  }
}

locals {
  prefix = "teste"
  common_tags = {
    Departamento = "sistemas",
    Fornecedor   = "A3DATA",
    Projeto      = "datalake"
  }
}
