resource "aws_lb" "lb" {
  name            = "matiu-lb"
  subnets         = var.public_subnets
  security_groups = var.security_groups
  idle_timeout    = 400
}
