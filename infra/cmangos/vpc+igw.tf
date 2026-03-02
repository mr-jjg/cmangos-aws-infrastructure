resource "aws_vpc" "cmangos" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = { Name = "cmangos-vpc" }
}

resource "aws_internet_gateway" "cmangos" {
  vpc_id = aws_vpc.cmangos.id
  tags   = { Name = "cmangos-igw" }
}

