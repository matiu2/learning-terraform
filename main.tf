module "networking" {
  source               = "./networking"
  vpc_cidr             = var.vpc_cidr
  public_subnet_count  = 2
  private_subnet_count = 3
  ssh_access_cidr      = var.ssh_access_cidr
  security_groups      = local.security_groups
  db_subnet_group      = false
}

module "database" {
  source                 = "./database"
  storage                = 10
  engine_version         = "5.7.22"
  instance_class         = "db.t2.micro"
  name                   = "rancher"
  username               = var.db_username
  password               = var.db_password
  subnet_group_name      = ""
  vpc_security_group_ids = []
  identifier             = "matiu-db"
  skip_final_snapshot    = true
}
