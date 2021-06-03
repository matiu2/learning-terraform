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

