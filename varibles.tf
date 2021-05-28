variable "aws_region" {
  type        = string
  description = "AWS Region name"
  default     = "ap-southeast-2"
}

variable "vpc_cidr" {
  type        = string
  description = "The cidr block for the VPC"
  default     = "10.124.0.0/16"
}

variable "ssh_access_cidr" {
  type        = string
  description = "The IP cidr block that is allowed to access the instances via SSH"
  validation {
    condition     = (try(cidrhost(var.ssh_access_cidr, 0), null) != null)
    error_message = "This must be a valid cidr block."
  }
}

variable "db_name" {
  type        = string
  description = "Database name"
  validation {
    condition     = length(var.db_name) > 0
    error_message = "Database name can't be empty."
  }
}

variable "db_username" {
  type      = string
  sensitive = true
  validation {
    condition     = length(var.db_username) > 0
    error_message = "DB Username can't be empty."
  }
}
variable "db_password" {
  type      = string
  sensitive = true
  validation {
    condition     = length(var.db_password) >= 8
    error_message = "DB Password must be at least 8 characters."
  }
}
