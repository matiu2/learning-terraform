module "networking" {
  source        = "./networking"
  vpc_cidr      = var.vpc_cidr
  public_cidrs  = [for n in range(1, 6, 2) : cidrsubnet(var.vpc_cidr, 8, n)]
  private_cidrs = [for n in range(2, 6, 2) : cidrsubnet(var.vpc_cidr, 8, n)]
}
