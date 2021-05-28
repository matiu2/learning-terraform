output "vpc_id" {
  value = aws_vpc.matiu_vpc.id
}
output "db_security_group_id" {
  value = aws_security_group.matiu-security-groups["rds"].id
}
output "db_subnet_group_name" {
  value = aws_db_subnet_group.matiu-rds-subnets.*.name
}

output "public_security_group_id" {
  value = aws_security_group.matiu-security-groups["public"].id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnet.*.id
}
