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


