provider "aws" {
  region = var.aws_region
}

# backend
terraform {
  backend "s3" {
    bucket = "terraform-1234123443214321"
    key    = "state/datalake/terraform.tfstate"
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
