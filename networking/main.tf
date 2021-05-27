### -- networking/main.tf --

resource "random_integer" "random" {
  min = 0
  max = 100
}

resource "aws_vpc" "matiu_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "matiu_vpc-${random_integer.random.id}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_subnet" "public_subnet" {
  count                   = var.public_subnet_count
  vpc_id                  = aws_vpc.matiu_vpc.id
  cidr_block              = local.public_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.azs.names[count.index % local.az_count]
  tags = {
    Name = "matiu-public-${count.index + 1}"
  }
}

resource "aws_route_table_association" "public-subnet-rta" {
  count          = var.public_subnet_count
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.matiu-public-rt.id
}

resource "aws_subnet" "private_subnet" {
  count      = var.private_subnet_count
  vpc_id     = aws_vpc.matiu_vpc.id
  cidr_block = local.private_cidrs[count.index]
  // We'll start referencing the random azs after the private subnet count, so
  // we don't just build in the same AZs as the public
  availability_zone = data.aws_availability_zones.azs.names[count.index % local.az_count]
  tags = {
    Name = "matiu-private-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "matiu-igw" {
  vpc_id = aws_vpc.matiu_vpc.id
  tags = {
    Name = "matiu-igw"
  }
}

resource "aws_route_table" "matiu-public-rt" {
  vpc_id = aws_vpc.matiu_vpc.id
  tags   = { Name = "matiu-public-rt" }
}

resource "aws_route" "matiu-public-route" {
  route_table_id         = aws_route_table.matiu-public-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.matiu-igw.id
}

resource "aws_default_route_table" "matiu-default-rt" {
  default_route_table_id = aws_vpc.matiu_vpc.default_route_table_id
  tags                   = { Name = "matiu-default-rt" }
}

resource "aws_security_group" "matiu-security-groups" {
  for_each    = var.security_groups
  name        = each.value.name
  description = each.value.description
  vpc_id      = aws_vpc.matiu_vpc.id
  dynamic "ingress" {
    for_each = each.value.ingress_rules
    content {
      from_port   = ingress.value.from
      to_port     = ingress.value.to
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  dynamic "ingress" {
    for_each = { for i in range(length(each.value.allowed_ingress_ports)) : "${i}" => { port = each.value.allowed_ingress_ports[i] } }
    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

resource "aws_security_group_rule" "matiu-security-groups-all-egress" {
  // All public security groups get full egress
  for_each          = aws_security_group.matiu-security-groups
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = each.value.id
}

