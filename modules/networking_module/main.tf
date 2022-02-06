# ....modules/networking-module/main.tf

resource "aws_vpc" "muyo_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = "true"
  enable_dns_support = "true"
}

resource "aws_internet_gateway" "muyo_igw" {
  vpc_id = aws_vpc.muyo_vpc.id
    
  tags = {
    Name = "Internet-Gateway"
  }

}


resource "aws_route_table" "muyo_public_rt" {
  vpc_id = aws_vpc.muyo_vpc.id

  tags = {
    Name = "muyo-public-route"
  }
}


resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.muyo_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.muyo_igw.id
}


resource "aws_default_route_table" "muyo_private_rt" {
  default_route_table_id = aws_vpc.muyo_vpc.default_route_table_id

  tags = {
    Name = "muyo-private-route"
  }
}

resource "aws_route_table_association" "public-rt_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.muyo_public_rt.id
}



resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.muyo_vpc.id
  cidr_block = var.public_subnet
    
    
  tags = {
    Name = "pub-subnet"
  }

}

resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.muyo_vpc.id
  cidr_block = var.private_subnet
    
    
  tags = {
    Name = "priv-subnet"
  }

}


resource "aws_security_group" "muyo_sg" {
  name        = "public_firewall"
  description = "Firewall for Public Access"
  vpc_id      = aws_vpc.muyo_vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}