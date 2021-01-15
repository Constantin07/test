terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.24.0"
    }
  }
}

provider "aws" {
  region = lookup(module.env.accounts[var.environment], "region")

  allowed_account_ids = [
    lookup(module.env.accounts[var.environment], "account"),
  ]

  assume_role {
    role_arn     = "arn:aws:iam::705505438149:role/TerraformAdmin"
    session_name = "Terraform"
  }
}
