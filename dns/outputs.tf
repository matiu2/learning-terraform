output "hostnames" {
  value = { for record in aws_route53_record.instances : "${record.name}.${data.aws_route53_zone.zone.name}" => record.records }
}
