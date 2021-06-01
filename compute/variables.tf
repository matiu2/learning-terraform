variable "instance_count" {
  type        = number
  description = "How many ec2 instances to create"
}

variable "instance_type" {
  type        = string
  description = "The EC2 instance type name"
  default     = "t3.micro"
}

variable "public_sg" {
  type        = string
  description = "The public security group ID where the EC2 instances will be created"
}

variable "public_subnets" {
  type        = list(string)
  description = "The list of subnet IDs where our public instances will be created"
}

variable "vol_size" {
  type        = number
  description = "The size in GiB for the volume for each instance"
  default     = 10
}
