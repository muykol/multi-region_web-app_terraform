#....main module for the multi-region deployment

module "us-east_networking" {
  source          = "./modules/networking_module"
  vpc_cidr        = "10.124.0.0/16"
  public_subnet   = "10.124.2.0/24"
  private_subnet  = "10.124.1.0/24"
  security_groups = local.security_groups
  providers = {
    aws = aws.useast
  }
}

module "us-west_networking" {
  source          = "./modules/networking_module"
  vpc_cidr        = "10.123.0.0/16"
  public_subnet   = "10.123.2.0/24"
  private_subnet  = "10.123.1.0/24"
  security_groups = local.security_groups
  providers = {
    aws = aws.uswest
  }
}

module "useast_loadbalancing" {
  source                  = "./modules/loadbalancing_module"
  public_sg               = module.us-east_networking.alb_sg
  public_subnet          = module.us-east_networking.public_subnet
  tg_port                 = 8080
  tg_protocol             = "HTTP"
  vpc_id                  = module.us-east_networking.vpc_id
  elb_healthy_threshold   = 2
  elb_unhealthy_threshold = 2
  elb_timeout             = 3
  elb_interval            = 30
  listener_port           = 8080
  listener_protocol       = "HTTP"
  providers = {
    aws = aws.useast
  }
}


module "uswest_loadbalancing" {
  source                  = "./modules/loadbalancing_module"
  public_sg               = module.us-west_networking.alb_sg
  public_subnet          = module.us-west_networking.public_subnet
  tg_port                 = 8080
  tg_protocol             = "HTTP"
  vpc_id                  = module.us-west_networking.vpc_id
  elb_healthy_threshold   = 2
  elb_unhealthy_threshold = 2
  elb_timeout             = 3
  elb_interval            = 30
  listener_port           = 8080
  listener_protocol       = "HTTP"
  providers = {
    aws = aws.uswest
  }
}