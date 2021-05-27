variable "vpc_cidr" {
  type        = string
  description = "The cidr for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_count" {
  type        = number
  description = "The number of public subnets to create in the VPC"
  validation {
    condition     = var.public_subnet_count < 255
    error_message = "Variable public_subnet_count must be less than 255."
  }
}

variable "private_subnet_count" {
  type        = number
  description = "The number of private subnets to create in the VPC"
  validation {
    condition     = var.private_subnet_count < 255
    error_message = "Variable private_subnet_count must be less than 255."
  }
}

variable "ssh_access_cidr" {
  type        = string
  description = "The IP cidr block that is allowed to access the instances via SSH"
  validation {
    condition     = (try(cidrhost(var.ssh_access_cidr, 0), null) != null)
    error_message = "This must be a valid cidr block."
  }
}

variable "security_groups" {
  description = "Inbound security groups"
}

variable "db_subnet_group" {
  type        = bool
  description = "Should we create a subnet group for the DB layer ? Generally yes in prod, and no in dev (due to less DB instances)"
}
