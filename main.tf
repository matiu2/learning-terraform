module "networking" {
  source               = "./networking"
  vpc_cidr             = var.vpc_cidr
  public_subnet_count  = 2
  private_subnet_count = 3
  ssh_access_cidr      = var.ssh_access_cidr
  security_groups      = local.security_groups
}
