data "aws_route53_zone" "zone" {
  name = var.zone_name
}

resource "aws_route53_record" "instances" {
  for_each = var.host-ip-mappings
  zone_id  = data.aws_route53_zone.zone.id
  name     = each.key
  type     = "A"
  ttl      = "5"
  records  = [each.value]
}
