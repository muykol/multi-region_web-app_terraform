# -----loadbalancing/main.tf ------

resource "aws_lb" "muyo_lb" {
  name            = "web-loadbalancer"
  subnets         = ["10.124.2.0/24", "10.123.2.0/24"]
  security_groups = [var.public_sg]
  idle_timeout    = 400
}

resource "aws_lb_target_group" "muyo_tg" {
  name     = "lb-target-group"
  port     = var.tg_port
  protocol = var.tg_protocol
  vpc_id   = var.vpc_id
  lifecycle {
    create_before_destroy = true
    ignore_changes        = [name]
  }
  health_check {
    healthy_threshold   = var.elb_healthy_threshold
    unhealthy_threshold = var.elb_unhealthy_threshold
    timeout             = var.elb_timeout
    interval            = var.elb_interval
  }
}

resource "aws_lb_listener" "muyo_lb_listener" {
  load_balancer_arn = aws_lb.muyo_lb.arn
  port              = var.listener_port
  protocol          = var.listener_protocol
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.muyo_tg.arn
  }
}