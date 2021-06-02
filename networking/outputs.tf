output "vpc_id" {
  value = aws_vpc.matiu_vpc.id
}
output "db_security_group_id" {
  value = aws_security_group.rds-sg.id
}
output "db_subnet_group_names" {
  value = aws_db_subnet_group.matiu-rds-subnets.*.name
}

output "instances_security_group_id" {
  value = aws_security_group.instance-sg.id
}

output "lb_security_group_id" {
  value = aws_security_group.lb-sg.id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnet.*.id
}
