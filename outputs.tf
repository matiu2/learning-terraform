output "vpc_id" {
  value = module.networking.vpc_id
}

output "instances" {
  value = module.compute.instances
}

output "dns" {
  value = module.dns.hostnames
}

output "aws_load_balancer_dns_name" {
  value = module.lb.dns_name
}

output "main_dns_name" {
  value = module.dns.main_hostname
}
