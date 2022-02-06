#....main module for the multi-region deployment

module "us-east1_networking" {
  source   = "./modules/networking_module"
  vpc_cidr = "10.124.0.0/16"
  public_subnet = "10.124.2.0/24"
  private_subnet = "10.124.1.0/24"
  providers = {
      aws = aws.useast
  }
}

module "us-west1_networking" {
  source   = "./modules/networking_module"
  vpc_cidr = "10.123.0.0/16"
  public_subnet = "10.123.2.0/24"
  private_subnet = "10.123.1.0/24"
  providers = {
      aws = aws.uswest
  }
}