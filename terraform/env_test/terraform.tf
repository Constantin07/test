terraform {
  backend "s3" {
    bucket         = "costea-states"
    key            = "test/core.tfstate"
    dynamodb_table = "costea-states"
    encrypt        = true
    region         = "eu-west-1"

    role_arn     = "arn:aws:iam::532814210204:role/TerraformAdmin"
    session_name = "Terraform"
  }
}

provider "aws" {
  region  = "us-east-1"
  version = ">= 1.28.0"

  allowed_account_ids = ["532814210204"]

  assume_role {
    role_arn     = "arn:aws:iam::532814210204:role/TerraformAdmin"
    session_name = "Terraform"
  }
}
