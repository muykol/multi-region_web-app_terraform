#....main module for the multi-region deployment

module "useast_networking" {
  source          = "./modules/networking_module"
  vpc_cidr        = "10.124.0.0/16"
  public_subnet   = "10.124.2.0/24"
  private_subnet  = "10.124.1.0/24"
  security_groups = local.security_groups
  providers = {
    aws = aws.useast
  }
}

module "uswest_networking" {
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
  public_sg               = module.useast_networking.alb_sg
  public_subnet          = module.useast_networking.public_subnet
  tg_port                 = 8080
  tg_protocol             = "HTTP"
  vpc_id                  = module.useast_networking.vpc_id
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
  public_sg               = module.uswest_networking.alb_sg
  public_subnet          = module.uswest_networking.public_subnet
  tg_port                 = 8080
  tg_protocol             = "HTTP"
  vpc_id                  = module.uswest_networking.vpc_id
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

module "useast_compute" {
  source         = "./modules/compute_module"
  #public_sg      = module.useast_networking.alb_sg
  web_sg     = module.useast_networking.web_sg
  private_subnet = module.useast_networking.private_subnet
  #public_subnet  = module.useast_networking.public_subnet
  elb            = module.useast_loadbalancing.elb
  alb_tg         = module.useast_loadbalancing.alb_tg
  key_name       = "muyo-server-key"
  providers = {
    aws = aws.useast
  }
}

module "uswest_compute" {
  source         = "./modules/compute_module"
  #public_sg      = module.uswest_networking.alb_sg
  web_sg     = module.uswest_networking.web_sg
  private_subnet = module.uswest_networking.private_subnet
  #public_subnet  = module.uswest_networking.public_subnet
  elb            = module.uswest_loadbalancing.elb
  alb_tg         = module.uswest_loadbalancing.alb_tg
  key_name       = "muyo-server-key"
  providers = {
    aws = aws.uswest
  }
}


/*module "useast_compute" {
  source              = "./modules/compute_module"
  private_sg     = module.useast_networking.web_sg
  private_subnet = module.useast_networking.private_subnet
  instance_count      = 2
  instance_type       = "t3.micro"
  vol_size            = "20"
  key_name            = "muyo-server-key"
  #user_data_path      = "${path.root}/userdata.tpl"
  lb_target_group_arn = module.useast_loadbalancing.lb_target_group_arn
  providers = {
    aws = aws.useast
  }
}

module "uswest_compute" {
  source              = "./modules/compute_module"
  private_sg     = module.uswest_networking.web_sg
  private_subnet = module.uswest_networking.private_subnet
  instance_count      = 2
  instance_type       = "t3.micro"
  vol_size            = "20"
  key_name            = "muyo-server-key"
  #user_data_path      = "${path.root}/userdata.tpl"
  lb_target_group_arn = module.uswest_loadbalancing.lb_target_group_arn
  providers = {
    aws = aws.uswest
  }
}*/