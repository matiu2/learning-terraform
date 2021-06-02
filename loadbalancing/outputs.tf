output "target_group_arn" {
  value       = aws_lb_target_group.tg.arn
  description = "ARN of the target group for the load balancer"
}
