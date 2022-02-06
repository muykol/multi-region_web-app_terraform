# ....modules/networking-module/variable.tf

variable "aws_region" {
    default = ["us-east-1", "us-west-1"]
}


variable vpc_cidr {
    default = "10.10.0.0/16"
}

variable public_subnet {
    default = "10.10.1.0/24"
}

variable private_subnet {
    default = "10.10.2.0/24"
}