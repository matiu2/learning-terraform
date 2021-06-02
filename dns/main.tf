data "aws_route53_zone" "zone" {
  name = var.zone_name
}

resource "aws_route53_record" "instances" {
  count   = length(var.host-ip-mappings)
  zone_id = data.aws_route53_zone.zone.id
  name    = var.host-ip-mappings[count.index].name
  type    = "A"
  ttl     = "5"
  records = [var.host-ip-mappings[count.index].public_ip]
}

resource "aws_route53_record" "main" {
  zone_id = data.aws_route53_zone.zone.id
  name    = "test"
  type    = "CNAME"
  ttl     = "5"
  records = [var.lb_dns_name]
}

