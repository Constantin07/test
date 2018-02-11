data "aws_region" "current" {
  name = "eu-west-1"
}

resource "aws_key_pair" "aws" {
  key_name   = "aws"
  public_key = "${file("${path.module}/keys/aws.key")}"
}
