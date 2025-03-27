output "alb_arn" {
  description = "ARN do Load Balancer"
  value       = aws_lb.alb.arn
}

output "target_group_arn" {
  description = "ARN do Target Group"
  value       = aws_lb_target_group.aws_alb_tg.arn
}

output "alb_listener_arn" {
  description = "ARN do Listener HTTP do Load Balancer"
  value       = aws_lb_listener.alb_listener.arn
}
