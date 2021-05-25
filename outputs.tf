output "vpc_id" {
  value = module.networking.vpc_id
}
output "public_availability_zones" {
  value = module.networking.public_availability_zones
}
output "private_availability_zones" {
  value = module.networking.private_availability_zones
}
