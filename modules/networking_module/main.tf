# ....modules/networking-module/main.tf

resource "aws_vpc" "muyo_vpc" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = "true"
    enable_dns_support = "true"
}

resource "aws_internet_gateway" "muyo_igw" {
    vpc_id = aws_vpc.muyo_vpc.id
}

resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.muyo_vpc.id
    cidr_block = var.public_subnet
}

resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.muyo_vpc.id
    cidr_block = var.private_subnet
}
