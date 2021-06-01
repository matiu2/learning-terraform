variable "host-ip-mappings" {
  type        = map(string)
  description = "Map of hostname->string, to create DNS A records of '(var.key).(zone_name)' (hostname) -> var.value (ip address) "
}

variable "zone_name" {
  type        = string
  description = "The DNS zone to use"
}
