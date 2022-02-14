# -----loadbalancing/main.tf ------

resource "aws_lb" "muyo_lb" {
  name            = "web-loadbalancer"
  subnets         = var.public_subnets
  security_groups = [var.public_sg]
  idle_timeout    = 400
}