output "vpc_id" {
  value = aws_vpc.matiu_vpc.id
}
output "db_security_group" {
  value = aws_security_group.matiu-security-groups["rds"].id
}

output "db_subnet_group" {
  value = aws_db_subnet_group.matiu-rds-subnets.*.name
}
