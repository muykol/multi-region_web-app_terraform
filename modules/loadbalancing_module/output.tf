# --- modules/loadbalancing_module/outputs.tf ---

output "elb" {
  value = aws_lb.muyo_lb.id
}

output "alb_tg" {
  value = aws_lb_target_group.muyo_tg.arn
}

output "alb_dns" {
  value = aws_lb.muyo_lb.dns_name
}