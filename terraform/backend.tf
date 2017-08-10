terraform {
  backend "s3" {
    bucket         = "costea-states"
    key            = "terraform/terraform.tfstate"
    dynamodb_table = "costea-states"
    encrypt        = "true"
    region         = "eu-west-1"
  }
}
