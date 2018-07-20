module "core" {
  source = "../modules/vpc"

  vpc_cidr                 = "${var.vpc_cidr}"
  availability_zones_count = "${var.availability_zones_count}"

  environment = "${var.environment}"
  project     = "${var.project}"

  extra_tags = {
    Environment = "${var.environment}"
    Project     = "${var.project}"
    ManagedBy   = "Terraform"
  }
}
