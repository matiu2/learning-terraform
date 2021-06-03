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

// RDS (private) subnets
resource "aws_route_table_association" "public-subnet-rta" {
  count          = var.public_subnet_count
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.matiu-public-rt.id
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
