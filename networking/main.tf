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

resource "aws_internet_gateway" "matiu-igw" {
  vpc_id = aws_vpc.matiu_vpc.id
  tags = {
    Name = "matiu-igw"
  }
}

// Routing

resource "aws_default_route_table" "matiu-default-rt" {
  default_route_table_id = aws_vpc.matiu_vpc.default_route_table_id
  tags                   = { Name = "matiu-default-rt" }
}
