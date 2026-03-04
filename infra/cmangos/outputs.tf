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
  value = aws_eip.cmangos.public_ip
}

output "rds_endpoint" {
  value = aws_db_instance.cmangos.address
}

output "rds_port" {
  value = aws_db_instance.cmangos.port
}

output "rds_db_name" {
  value = aws_db_instance.cmangos.db_name
}
