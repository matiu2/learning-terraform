locals {
  // Although this creates 255 subnets, we'll only `var.public_subnet_count` of them
  public_cidrs = [for n in range(1, 255, 2) : cidrsubnet(var.vpc_cidr, 8, n)]
  // Although this creates 255 subnets, we'll only `var.private_subnet_count` of them
  private_cidrs = [for n in range(2, 255, 2) : cidrsubnet(var.vpc_cidr, 8, n)]
  // How many AZs are there
  az_count = length(data.aws_availability_zones.azs.names)
}
