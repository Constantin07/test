resource "aws_vpc" "vpc" {
  cidr_block           = "${var.vpc_cidr}"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags {
    Name    = "vpc"
    Env     = "${var.environment}"
    Project = "${var.project}"
  }
}

resource "aws_vpc_endpoint" "vpc_endpoint_s3" {
  vpc_id       = "${aws_vpc.vpc.id}"
  service_name = "com.amazonaws.eu-west-1.s3"

  route_table_ids = [
    "${aws_route_table.public_rt.id}",
    "${aws_route_table.private_rt.id}",
  ]
}

resource "aws_vpc_endpoint" "vpc_endpoint_dynamodb" {
  vpc_id       = "${aws_vpc.vpc.id}"
  service_name = "com.amazonaws.eu-west-1.dynamodb"
}

resource "aws_vpc_dhcp_options" "dhcp_option" {
  domain_name         = "test.local"
  domain_name_servers = ["8.8.8.8", "8.8.4.4"]
  ntp_servers         = ["194.35.252.7", "81.168.77.149"]
  netbios_node_type   = 2

  tags {
    Name    = "dhcp-option"
    Env     = "${var.environment}"
    Project = "${var.project}"
  }
}

resource "aws_vpc_dhcp_options_association" "dhcp_options_association" {
  vpc_id          = "${aws_vpc.vpc.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.dhcp_option.id}"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name    = "gateway"
    Env     = "${var.environment}"
    Project = "${var.project}"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name    = "public_rt"
    Env     = "${var.environment}"
    Project = "${var.project}"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name    = "private_rt"
    Env     = "${var.environment}"
    Project = "${var.project}"
  }
}

resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  availability_zone       = "eu-west-1a"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"

  tags {
    Name    = "public_subnet_a"
    Env     = "${var.environment}"
    Project = "${var.project}"
  }
}

resource "aws_route_table_association" "rt_a" {
  subnet_id      = "${aws_subnet.public_subnet_a.id}"
  route_table_id = "${aws_route_table.public_rt.id}"
}

resource "aws_subnet" "public_subnet_b" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  availability_zone       = "eu-west-1b"
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true"

  tags {
    Name    = "public_subnet_b"
    Env     = "${var.environment}"
    Project = "${var.project}"
  }
}

resource "aws_route_table_association" "rt_b" {
  subnet_id      = "${aws_subnet.public_subnet_b.id}"
  route_table_id = "${aws_route_table.public_rt.id}"
}

resource "aws_subnet" "public_subnet_c" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  availability_zone       = "eu-west-1c"
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = "true"

  tags {
    Name    = "public_subnet_c"
    Env     = "${var.environment}"
    Project = "${var.project}"
  }
}

resource "aws_route_table_association" "rt_c" {
  subnet_id      = "${aws_subnet.public_subnet_c.id}"
  route_table_id = "${aws_route_table.public_rt.id}"
}

resource "aws_security_group" "vpc_sg" {
  name        = "vpc_sg"
  description = "VPC security group"

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "icmp"
    self      = true
  }

  tags {
    Name    = "vpc_sg"
    Env     = "${var.environment}"
    Project = "${var.project}"
  }
}

resource "aws_security_group" "dev_sg" {
  name        = "${var.environment}_sg"
  description = "Dev environment security group"

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "icmp"
    security_groups = ["${aws_security_group.vpc_sg.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name    = "dev_sg"
    Env     = "${var.environment}"
    Project = "${var.project}"
  }
}

resource "aws_security_group" "server_sg" {
  name        = "server_sg"
  description = "Dev server security group"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name    = "server_sg1"
    Env     = "${var.environment}"
    Project = "${var.project}"
  }
}
