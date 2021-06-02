output "vpc_id" {
  value = module.networking.vpc_id
}

output "instances" {
  value = module.compute.instances
}

output "dns" {
  value = module.dns.hostnames
}
