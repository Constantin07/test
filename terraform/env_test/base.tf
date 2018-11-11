module "env" {
  source = "../modules/env"
}

module "core" {
  source = "../modules/vpc"

  vpc_cidr                 = "${var.vpc_cidr}"
  internal_dns_domain      = "${var.internal_dns_domain}"
  availability_zones_count = "${var.availability_zones_count}"

  environment = "${var.environment}"
  project     = "${var.project}"

  extra_tags = {
    Environment = "${var.environment}"
    Project     = "${var.project}"
    ManagedBy   = "Terraform"
  }
}

module "key_pairs" {
  source = "../modules/key_pairs"

  key_name_prefix = "${var.project}_${var.environment}"
}
