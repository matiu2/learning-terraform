resource "aws_lb" "lb" {
  name            = "matiu-lb"
  subnets         = var.public_subnets
  security_groups = var.security_groups
  idle_timeout    = 400
}

resource "aws_lb_target_group" "tg" {
  name     = "matiu-lb-tg-${substr(uuid(), 0, 3)}"
  vpc_id   = var.vpc_id
  port     = var.tg_port
  protocol = var.tg_protocol
  health_check {
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
    interval            = var.interval
  }
}
