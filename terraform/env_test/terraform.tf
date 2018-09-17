terraform {
  backend "s3" {
    bucket         = "costea2-states"
    key            = "test/core.tfstate"
    //dynamodb_table = "costea-states"
    encrypt        = true
    region         = "eu-west-1"

    role_arn     = "arn:aws:iam::705505438149:role/TerraformAdmin"
    session_name = "Terraform"
  }
}

provider "aws" {
  region  = "${var.region}"
  version = ">= 1.36.0"

  allowed_account_ids = ["705505438149"]

  assume_role {
    role_arn     = "arn:aws:iam::705505438149:role/TerraformAdmin"
    session_name = "Terraform"
  }
}
