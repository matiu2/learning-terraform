resource "aws_db_instance" "matiu-db" {
  allocated_storage      = var.storage # Gigibytes
  engine                 = "mysql"
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  name                   = var.name
  username               = var.username
  password               = var.password
  db_subnet_group_name   = var.subnet_group_name
  vpc_security_group_ids = var.vpc_security_group_ids
  identifier             = var.identifier
  skip_final_snapshot    = var.skip_final_snapshot
  tags = {
    Name = "matiu-db"
  }
}
