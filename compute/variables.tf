variable "ami_id" {
  type        = string
  description = "The AMI ID for the image, from which to build the instances. eg. ami-0585c832178a3fc32"
}

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

variable "ssh-pub-key-name" {
  type        = string
  description = "The AWS name for the public part of the ssh key, used to access the instances via SSH"
}

variable "ssh-pub-key-path" {
  type        = string
  description = "The path from which to load the SSH public key file data"
  default     = "~/.ssh/id_rsa.pub"
}

variable "user_data_tmpl_path" {
  type        = string
  description = "The path to the terraform template file that will be used to bootstrap the EC2 instances (in their user_data)"
}

variable "db_endpoint" {
  type        = string
  description = "The endpoint so the EC2 instances can connect to the database"
}

variable "db_username" {
  type        = string
  description = "DB Username"
}

variable "db_password" {
  type        = string
  description = "DB password"
}

variable "db_name" {
  type        = string
  description = "Name of the database to connect to"
}

variable "aws_lb_target_group_arn" {
  type        = string
  description = "The ARN of the target group for the load balancer"
}

variable "ssh_key_path" {
  type        = string
  description = "Path to your SSH private key"
  default     = "~/.ssh/id_rsa"
}
