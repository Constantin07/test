terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.38.0"
    }
  }
}

provider "aws" {
  region = lookup(module.env.accounts[var.environment], "region")
}
