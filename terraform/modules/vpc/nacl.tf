resource "aws_network_acl" "private" {
  vpc_id = aws_vpc.default.id

  subnet_ids = aws_subnet.private.*.id

  tags = merge(map(
    "Name", "${var.environment}-private-nacl"
  ), var.extra_tags)
}

/* Outbound rules */

resource "aws_network_acl_rule" "private_egress" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 100
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 65535
}

/* Inbound rules */

resource "aws_network_acl_rule" "private_ingress_ephemeral_tcp" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 65535
}

resource "aws_network_acl_rule" "private_ingress_ephemeral_udp" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 200
  egress         = false
  protocol       = "udp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 65535
}
