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
