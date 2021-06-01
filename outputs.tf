output "vpc_id" {
  value = module.networking.vpc_id
}

output "ssh_access" {
  value = module.compute.ssh_access
}

output "dns" {
  value = module.dns.hostnames
}
