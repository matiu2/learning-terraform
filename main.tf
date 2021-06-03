module "networking" {
  source               = "./networking"
  vpc_cidr             = var.vpc_cidr
  public_subnet_count  = 2
  private_subnet_count = 3
  ssh_access_cidr      = var.ssh_access_cidr
  db_subnet_group      = true
  public_lb_port       = 80
  instance_to_lb_port  = 8000
}

module "database" {
  source                 = "./database"
  storage                = 10
  engine_version         = "5.7.22"
  instance_class         = "db.t2.micro"
  name                   = var.db_name
  username               = var.db_username
  password               = var.db_password
  subnet_group_name      = module.networking.db_subnet_group_names[0]
  vpc_security_group_ids = [module.networking.db_security_group_id]
  identifier             = "matiu-db"
  skip_final_snapshot    = true
}
module "lb" {
  source              = "./loadbalancing"
  security_groups     = [module.networking.lb_security_group_id]
  public_subnets      = module.networking.public_subnet_ids
  vpc_id              = module.networking.vpc_id
  healthy_threshold   = 2
  unhealthy_threshold = 2
  tg_port             = 8000
  tg_protocol         = "HTTP"
  interval            = 30
  listener_port       = 80
  listener_protocol   = "HTTP"
}

module "compute" {
  source              = "./compute"
  ami_id              = var.ami_id
  instance_count      = var.instance_count
  instance_type       = "t3.micro"
  public_sg           = module.networking.instances_security_group_id
  public_subnets      = module.networking.public_subnet_ids
  vol_size            = 10
  ssh-pub-key-name    = "matiu-ssh-key"
  ssh-pub-key-path    = "~/.ssh/id_rsa.pub"
  ssh_key_path        = var.ssh_key_path
  db_endpoint         = module.database.endpoint
  db_username         = var.db_username
  db_password         = var.db_password
  db_name             = var.db_name
  user_data_tmpl_path = "userdata.tpl"
  depends_on = [
    module.database, module.networking
  ]
  aws_lb_target_group_arn = module.lb.target_group_arn
}

module "dns" {
  source           = "./dns"
  zone_name        = var.dns-zone-name
  host-ip-mappings = [for i in range(var.instance_count) : { name = module.compute.instances[i].name, public_ip = module.compute.instances[i].public_ip }]
  lb_dns_name      = module.lb.dns_name
}
