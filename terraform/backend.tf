terraform {
  backend "s3" {
    bucket         = "costea2-states"
    key            = "terraform/terraform.tfstate"
    //dynamodb_table = "costea-states"
    encrypt        = true
    region         = "eu-west-1"
  }
}
