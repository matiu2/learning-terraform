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
}

resource "aws_subnet" "public_subnet" {
  count                   = var.public_subnet_count
  vpc_id                  = aws_vpc.matiu_vpc.id
  cidr_block              = local.public_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = local.availability_zones[count.index % length(local.availability_zones)]
  tags = {
    Name = "matiu-public-${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnet" {
  count             = var.private_subnet_count
  vpc_id            = aws_vpc.matiu_vpc.id
  cidr_block        = local.private_cidrs[count.index]
  availability_zone = local.availability_zones[count.index % length(local.availability_zones)]
  tags = {
    Name = "matiu-private-${count.index + 1}"
  }
}
