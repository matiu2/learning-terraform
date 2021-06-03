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

resource "aws_db_subnet_group" "matiu-rds-subnets" {
  count      = var.db_subnet_group ? 1 : 0
  name       = "matiu-rds-subnet-group"
  subnet_ids = aws_subnet.private_subnet.*.id
  tags = {
    Name = "matiu-rds-subnet-group"
  }
}
