# ----modules/compute_module/variable.tf

#variable "alb_sg" {}
variable "web_sg" {}
variable "private_subnet" {}
#variable "public_subnet" {}
variable "key_name" {}
variable "elb" {}
variable "alb_tg" {}
variable "web_server_instance_type" {
  type    = string
  default = "t2.micro"
}
