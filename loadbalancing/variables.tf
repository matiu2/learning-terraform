variable "public_subnets" {
  type        = list(string)
  description = "All the subnets that the load balancers should be in"
}

variable "security_groups" {
  type        = list(string)
  description = "A list of security group IDs to assign to the LB. Only valid for Application Load balancers"
}
