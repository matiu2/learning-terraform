module "networking" {
  source               = "./networking"
  vpc_cidr             = var.vpc_cidr
  public_subnet_count  = 3
  private_subnet_count = 3
}
