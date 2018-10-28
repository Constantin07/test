provider "aws" {
  region  = "${var.region}"
  version = ">= 1.41.0"

  allowed_account_ids = ["705505438149"]

  assume_role {
    role_arn     = "arn:aws:iam::705505438149:role/TerraformAdmin"
    session_name = "Terraform"
  }
}
