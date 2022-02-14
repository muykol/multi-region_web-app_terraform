# -----networking/output.tf -------

output "vpc_id" {
    value = aws_vpc.muyo_vpc.id
}


output "public_subnet" {
    value = aws_subnet.public_subnet.id
}

output "private_subnet" {
    value = aws_subnet.private_subnet.id
}

output "alb_sg" {
  value = aws_security_group.muyo_sg["public"].id
}

output "web_sg" {
  value = aws_security_group.muyo_sg["private"].id
}
