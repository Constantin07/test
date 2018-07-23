output "vpc_id" {
  value = "${aws_vpc.default.id}"
}

output "vpc_cidr_block" {
  value = "${aws_vpc.default.cidr_block}"
}

output "vpc_internet_gateway_id" {
  value = "${aws_internet_gateway.default.id}"
}

output "availability_zones" {
  value = "${local.availability_zones}"
}

output "private_subnets" {
  value = "${aws_subnet.private.*.id}"
}

output "public_subnets" {
  value = "${aws_subnet.public.*.id}"
}

output "network_acl_private" {
  value = "${aws_network_acl.private.id}"
}
