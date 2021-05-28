variable "storage" {
  type        = number
  description = "Size of database disk is gigibytes"
}

variable "engine_version" {}

variable "instance_class" {}

variable "name" {}

variable "username" {}

variable "password" {}

variable "subnet_group_name" {}

variable "vpc_security_group_ids" {}

variable "identifier" {}

variable "skip_final_snapshot" {}
