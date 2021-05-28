variable "public_subnets" {
  type        = list(string)
  description = "All the subnets that the load balancers should be in"
}

variable "security_groups" {
  type        = list(string)
  description = "A list of security group IDs to assign to the LB. Only valid for Application Load balancers"
}

variable "tg_port" {
  type        = number
  description = "The port number for the load balancer target group"
  validation {
    condition     = var.tg_port > 0 && var.tg_port <= 65535
    error_message = "Targe port must be between 1 and 65535 (inclusive)."
  }
}
variable "tg_protocol" {
  type        = string
  description = "Protocol to use to connect to the target group"
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC for the load balancer target group"
}

variable "healthy_threshold" {
  type        = number
  description = "Number of consecutive health checks successes required before considering an unhealthy target healthy"
}

variable "unhealthy_threshold" {
  type        = number
  description = "Number of consecutive health check failures required before considering the target unhealthy"
}

variable "interval" {
  type        = number
  description = "valueApproximate amount of time, in seconds, between health checks of an individual target"
  validation {
    condition     = var.interval >= 5 && var.interval <= 300
    error_message = "Interval must be between 5 and 300 seconds."
  }
}
