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

