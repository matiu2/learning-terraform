variable "host-ip-mappings" {
  type        = list(map(string))
  description = "List of {hostname, public_ip}, to create DNS A records of '(hostname).(var.zone_name)' (public_ip)"
}

variable "zone_name" {
  type        = string
  description = "The DNS zone to use"
}

variable "lb_dns_name" {
  type        = string
  description = "The DNS name provided by AWS for the load balancer. This will get CNAME mapped to test.$${zone_name}"
}
