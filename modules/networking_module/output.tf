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

/*
output "public_sg" {
    value = aws_security_group.public_sg.id
}
*/