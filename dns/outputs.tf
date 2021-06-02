output "hostnames" {
  value = [for record in aws_route53_record.instances : {
    full_hostname = "${record.name}.${data.aws_route53_zone.zone.name}"
    ip_addresses  = record.records
  }]
}

output "main_hostname" {
  value = "${aws_route53_record.main.name}.${data.aws_route53_zone.zone.name}"
}
