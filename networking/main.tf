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

// RDS (private) subnets
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

resource "aws_db_subnet_group" "matiu-rds-subnets" {
  count      = var.db_subnet_group ? 1 : 0
  name       = "matiu-rds-subnet-group"
  subnet_ids = aws_subnet.private_subnet.*.id
  tags = {
    Name = "matiu-rds-subnet-group"
  }
}

resource "aws_internet_gateway" "matiu-igw" {
  vpc_id = aws_vpc.matiu_vpc.id
  tags = {
    Name = "matiu-igw"
  }
}

// Routing

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

// Instances Security group ////
resource "aws_security_group" "instance-sg" {
  name        = "instance-sg"
  description = "Security group for ec2 instances"
  vpc_id      = aws_vpc.matiu_vpc.id
}

resource "aws_security_group_rule" "instance-ssh" {
  security_group_id = aws_security_group.instance-sg.id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [var.ssh_access_cidr]
}

resource "aws_security_group_rule" "instance-kubectl" {
  security_group_id = aws_security_group.instance-sg.id
  type              = "ingress"
  from_port         = 6443
  to_port           = 6443
  protocol          = "tcp"
  cidr_blocks       = [var.ssh_access_cidr]
}

resource "aws_security_group_rule" "instance-http-out" {
  // This is required at the start to install kubectl (when running the provisioners)
  security_group_id = aws_security_group.instance-sg.id
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "instance-https-out" {
  // This is required at the start to install kubectl (when running the provisioners)
  security_group_id = aws_security_group.instance-sg.id
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "instance-loadbalancer" {
  // Allow the LB to talk to the instances on whatever port they're serving on
  security_group_id        = aws_security_group.instance-sg.id
  type                     = "ingress"
  from_port                = var.instance_to_lb_port
  to_port                  = var.instance_to_lb_port
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.lb-sg.id
}

// Load balancer security group /////

resource "aws_security_group" "lb-sg" {
  name        = "lb-sg"
  description = "Security group for the load balancer"
  vpc_id      = aws_vpc.matiu_vpc.id
}

resource "aws_security_group_rule" "lb-incoming" {
  // Allow the world to hit the load balancer on whatever port it's serving on
  security_group_id = aws_security_group.lb-sg.id
  type              = "ingress"
  from_port         = var.public_lb_port
  to_port           = var.public_lb_port
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "lb-out" {
  // Allow the load balancer to reach out to the instances
  security_group_id        = aws_security_group.lb-sg.id
  type                     = "egress"
  from_port                = var.instance_to_lb_port
  to_port                  = var.instance_to_lb_port
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.instance-sg.id
}

/// RDS Security group ///

resource "aws_security_group" "rds-sg" {
  name        = "rds-sg"
  description = "Security group for the database"
  vpc_id      = aws_vpc.matiu_vpc.id
}

resource "aws_security_group_rule" "instances-to-rds" {
  type                     = "ingress"
  security_group_id        = aws_security_group.rds-sg.id
  source_security_group_id = aws_security_group.instance-sg.id
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
}
