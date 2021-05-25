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
  count                   = length(var.public_cidrs)
  vpc_id                  = aws_vpc.matiu_vpc.id
  cidr_block              = var.public_cidrs[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "matiu-public-${count.index + 1}"
  }
}
