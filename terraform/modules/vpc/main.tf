data "aws_region" "current" {}

resource "aws_vpc" "default" {
  cidr_block           = "${var.vpc_cidr}"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  enable_classiclink             = false
  enable_classiclink_dns_support = false

  assign_generated_ipv6_cidr_block = false

  tags = "${merge(map(
      "Name", "${var.project}-${var.environment}-vpc"
    ), var.extra_tags)}"
}

resource "aws_vpc_dhcp_options" "default" {
  domain_name         = "${data.aws_region.current.name}.compute.internal"
  domain_name_servers = ["AmazonProvidedDNS"]

  tags = "${merge(map(
      "Name", "${var.project}-${var.environment}-dhcp-options"
    ), var.extra_tags)}"
}

resource "aws_vpc_dhcp_options_association" "default" {
  vpc_id          = "${aws_vpc.default.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.default.id}"
}

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  availability_zones = "${slice(data.aws_availability_zones.available.names, length(data.aws_availability_zones.available.names)-var.availability_zones_count, length(data.aws_availability_zones.available.names))}"
}

resource "aws_subnet" "private" {
  count = "${length(local.availability_zones)}"

  vpc_id            = "${aws_vpc.default.id}"
  cidr_block        = "${cidrsubnet(aws_vpc.default.cidr_block, 2, 0 + count.index)}"
  availability_zone = "${element(local.availability_zones, count.index)}"

  tags = "${merge(map(
      "Name", "${var.project}-${var.environment}-private-${substr(element(local.availability_zones, count.index), -1, 1)}"
    ), var.extra_tags)}"
}

resource "aws_subnet" "public" {
  count = "${length(local.availability_zones)}"

  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "${cidrsubnet(aws_vpc.default.cidr_block, 2, 2 + count.index)}"
  availability_zone       = "${element(local.availability_zones, count.index)}"
  map_public_ip_on_launch = true

  tags = "${merge(map(
      "Name", "${var.project}-${var.environment}-public-${substr(element(local.availability_zones, count.index), -1, 1)}"
    ), var.extra_tags)}"
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"

  tags = "${merge(map(
      "Name", "${var.project}-${var.environment}-gw"
    ), var.extra_tags)}"
}

/*
resource "aws_eip" "nat_gateway" {
  count = "${length(local.availability_zones)}"

  vpc = true
}

resource "aws_nat_gateway" "default" {
  count = "${length(local.availability_zones)}"

  allocation_id = "${element(aws_eip.nat_gateway.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"

  tags = "${merge(map(
      "Name", "${var.project}-${var.environment}-nat-gw"
    ), var.extra_tags)}"

  depends_on = ["aws_internet_gateway.default"]
}
*/

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = "${aws_vpc.default.id}"
  service_name = "com.amazonaws.${data.aws_region.current.name}.s3"
}

resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id       = "${aws_vpc.default.id}"
  service_name = "com.amazonaws.${data.aws_region.current.name}.dynamodb"
}
