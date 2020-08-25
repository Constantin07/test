provider "aws" {
  region  = lookup(module.env.accounts[var.environment], "region")
  version = "~> 3.3.0"

  allowed_account_ids = [
    "${lookup(module.env.accounts[var.environment], "account")}",
  ]

  assume_role {
    role_arn     = "arn:aws:iam::705505438149:role/TerraformAdmin"
    session_name = "Terraform"
  }
}
