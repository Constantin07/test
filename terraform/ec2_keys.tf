data "aws_region" "current" {
  current = true
}

resource "aws_key_pair" "aws" {
  key_name   = "aws"
  public_key = "${file("${path.module}/keys/aws.key")}"
}
