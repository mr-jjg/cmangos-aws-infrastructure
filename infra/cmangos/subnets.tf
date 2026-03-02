resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.cmangos.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = var.az_a
  map_public_ip_on_launch = true

  tags = { Name = "cmangos-public-a" }
}

resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.cmangos.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = var.az_a

  tags = { Name = "cmangos-private-a" }
}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.cmangos.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = var.az_b

  tags = { Name = "cmangos-private-b" }
}

resource "aws_db_subnet_group" "cmangos" {
  name       = "cmangos-db-subnets"
  subnet_ids = [aws_subnet.private_a.id, aws_subnet.private_b.id]

  tags = { Name = "cmangos-db-subnets" }
}
