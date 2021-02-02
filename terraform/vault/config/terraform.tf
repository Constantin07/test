terraform {
  backend "s3" {
    bucket = "dev-710782875474-terraform-state"
    key    = "terraform/vault/config.tfstate"

    dynamodb_table = "terraform-lock"
    encrypt        = true
    region         = "eu-west-1"
  }
}
