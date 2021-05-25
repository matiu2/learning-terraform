output "vpc_id" {
  value = module.networking.vpc_id
}

output "public_availability_zones" {
  value = module.networking.public_availability_zones
}
