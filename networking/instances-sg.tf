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


