/**
* Terraform module to spin up a VPC
* The subnet CIDR blocks will be automatically calculated based on the number of AZs in region.
*/

data "aws_region" "current" {}

resource "aws_vpc" "default" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  enable_classiclink             = false
  enable_classiclink_dns_support = false

  assign_generated_ipv6_cidr_block = true

  tags = merge(map(
    "Name", "${var.environment}-vpc"
  ), var.extra_tags)
}

locals {
  domain_name = "${var.internal_dns_domain == "" ? "${data.aws_region.current.name}.compute.internal" : var.internal_dns_domain}"
}

resource "aws_vpc_dhcp_options" "default" {
  domain_name         = local.domain_name
  domain_name_servers = ["AmazonProvidedDNS"]

  tags = merge(map(
    "Name", "${var.environment}-dhcp-options"
  ), var.extra_tags)
}

resource "aws_vpc_dhcp_options_association" "default" {
  vpc_id          = aws_vpc.default.id
  dhcp_options_id = aws_vpc_dhcp_options.default.id
}

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  availability_zones = slice(data.aws_availability_zones.available.names, length(data.aws_availability_zones.available.names) - var.availability_zones_count, length(data.aws_availability_zones.available.names))
  newbits            = ceil(log(2 * var.availability_zones_count, 2))
}

resource "aws_subnet" "private" {
  count = length(local.availability_zones)

  vpc_id            = aws_vpc.default.id
  cidr_block        = cidrsubnet(aws_vpc.default.cidr_block, local.newbits, 0 + count.index)
  availability_zone = element(local.availability_zones, count.index)

  tags = merge(map(
    "Name", "${var.environment}-subnet-private-${substr(element(local.availability_zones, count.index), -1, 1)}",
    "kubernetes.io/role/internal-elb", "1"
  ), var.extra_tags)
}

resource "aws_subnet" "public" {
  count = length(local.availability_zones)

  vpc_id                  = aws_vpc.default.id
  cidr_block              = cidrsubnet(aws_vpc.default.cidr_block, local.newbits, var.availability_zones_count + count.index)
  availability_zone       = element(local.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = merge(map(
    "Name", "${var.environment}-subnet-public-${substr(element(local.availability_zones, count.index), -1, 1)}",
    "kubernetes.io/role/elb", "1"
  ), var.extra_tags)
}

resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id

  tags = merge(map(
    "Name", "${var.environment}-gw"
  ), var.extra_tags)
}

resource "aws_egress_only_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id
}

/*

resource "aws_eip" "nat_gateway" {
  count = length(local.availability_zones)

  vpc = true

  tags = merge(map(
      "Name", "${var.environment}-nat-gw-${substr(element(local.availability_zones, count.index), -1, 1)}"
    ), var.extra_tags)
}

resource "aws_nat_gateway" "default" {
  count = length(local.availability_zones)

  allocation_id = element(aws_eip.nat_gateway.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)

  tags = merge(map(
      "Name", "${var.environment}-nat-gw"
    ), var.extra_tags)

  depends_on = ["aws_internet_gateway.default"]
}

*/

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.default.id
  service_name = "com.amazonaws.${data.aws_region.current.name}.s3"
}

resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id       = aws_vpc.default.id
  service_name = "com.amazonaws.${data.aws_region.current.name}.dynamodb"
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.default.id

  tags = merge(map(
    "Name", "${var.environment}-public-rt"
  ), var.extra_tags)
}

resource "aws_route" "outer_igw" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.default.id
}

resource "aws_vpc_endpoint_route_table_association" "public_s3" {
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
  route_table_id  = aws_route_table.public.id
}

resource "aws_vpc_endpoint_route_table_association" "public_dynamodb" {
  vpc_endpoint_id = aws_vpc_endpoint.dynamodb.id
  route_table_id  = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  count = length(local.availability_zones)

  vpc_id = aws_vpc.default.id

  tags = merge(map(
    "Name", "${var.environment}-private-rt-${substr(element(local.availability_zones, count.index), -1, 1)}"
  ), var.extra_tags)
}

/*
resource "aws_route" "private_natgw" {
  count = length(local.availability_zones)

  route_table_id         = element(aws_route_table.private.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.default.*.id, count.index)
}

resource "aws_vpc_endpoint_route_table_association" "private_s3" {
  count = length(local.availability_zones)

  vpc_endpoint_id = aws_vpc_endpoint.s3.id
  route_table_id  = element(aws_route_table.private.*.id, count.index)
}

resource "aws_vpc_endpoint_route_table_association" "private_dynamodb" {
  count = length(local.availability_zones)

  vpc_endpoint_id = aws_vpc_endpoint.dynamodb.id
  route_table_id  = element(aws_route_table.private.*.id, count.index)
}
*/

resource "aws_route_table_association" "public" {
  count = length(local.availability_zones)

  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count = length(local.availability_zones)

  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}
