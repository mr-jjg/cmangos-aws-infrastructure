output "vpc_id" {
  value = aws_vpc.cmangos.id
}

output "public_subnet_id" {
  value = aws_subnet.public_a.id
}

output "cmangos_ec2_sg_id" {
  value = aws_security_group.cmangos_sg.id
}

output "public_ip" {
  value = aws_instance.cmangos.public_ip
}
