variable "vpc_cidr" {
  type        = string
  description = "The cidr for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_cidrs" {
  type        = list(string)
  description = "The CIDR's of the subnets that will have routes to the internet gateway"
}
