output "vpc_id" {
  value = aws_vpc.matiu_vpc.id
}
output "public_availability_zones" {
  value = [for net in aws_subnet.public_subnet : net.availability_zone]
}

output "private_availability_zones" {
  value = [for net in aws_subnet.private_subnet : net.availability_zone]
}
