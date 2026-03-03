resource "aws_security_group" "cmangos_sg" {
  name        = "cmangos-ec2-sg"
  description = "Allow SSH from my IP only"
  vpc_id      = aws_vpc.cmangos.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_allowed_cidrs
  }

  ingress {
    description = "WoW Auth (realmd)"
    from_port   = 3724
    to_port     = 3724
    protocol    = "tcp"
    cidr_blocks = var.ssh_allowed_cidrs
  }

  ingress {
    description = "WoW World (mangosd)"
    from_port   = 8085
    to_port     = 8085
    protocol    = "tcp"
    cidr_blocks = var.ssh_allowed_cidrs
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "cmangos-ec2-sg" }
}

resource "aws_security_group" "rds_sg" {
  name        = "cmangos-rds-sg"
  description = "Allow MySQL from cmangos EC2 SG only"
  vpc_id      = aws_vpc.cmangos.id

  ingress {
    description     = "MySQL from game server SG"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.cmangos_sg.id]
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "cmangos-rds-sg" }
}
