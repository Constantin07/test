/**
* Module used to generate SSH keypars
*/

locals {
  key_name_prefix    = "${var.key_name_prefix == "" ? terraform.workspace : var.key_name_prefix}"
  timestamp_yyyymmdd = "${replace(substr(timestamp(), 0, 10), "-", "")}"
}

/* Key used in public subnets */

resource "tls_private_key" "public" {
  algorithm   = "${var.private_key_algorithm}"
  rsa_bits    = "${var.private_key_rsa_bits}"
  ecdsa_curve = "${var.private_key_ecdsa_curve}"
}

resource "aws_key_pair" "public" {
  key_name   = "${local.key_name_prefix}_public_${local.timestamp_yyyymmdd}"
  public_key = "${tls_private_key.public.public_key_openssh}"

  lifecycle {
    ignore_changes = [
      "key_name",
    ]
  }
}

/* Key used in private subnets */

resource "tls_private_key" "private" {
  algorithm   = "${var.private_key_algorithm}"
  rsa_bits    = "${var.private_key_rsa_bits}"
  ecdsa_curve = "${var.private_key_ecdsa_curve}"
}

resource "aws_key_pair" "private" {
  key_name   = "${local.key_name_prefix}_private_${local.timestamp_yyyymmdd}"
  public_key = "${tls_private_key.private.public_key_openssh}"

  lifecycle {
    ignore_changes = [
      "key_name",
    ]
  }
}
