terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.17"
    }
  }
}

provider "aws" {
  region = lookup(module.env.accounts[var.environment], "region")
}
