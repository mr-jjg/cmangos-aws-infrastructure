terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.67"
    }
  }
}

provider "aws" {
  region  = var.region
  profile = var.profile
}

data "aws_ami" "ubuntu_2404" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

resource "aws_eip" "cmangos" {
  vpc = true
}

resource "aws_eip_association" "cmangos" {
  instance_id   = aws_instance.cmangos.id
  allocation_id = aws_eip.cmangos.id
}

resource "aws_instance" "cmangos" {
  ami           = data.aws_ami.ubuntu_2404.id
  instance_type = var.instance_type
  key_name      = var.key_name

  subnet_id              = aws_subnet.public_a.id
  vpc_security_group_ids = [aws_security_group.cmangos_sg.id]

  iam_instance_profile = aws_iam_instance_profile.cmangos.name

  root_block_device {
    volume_type           = "gp3"
    volume_size           = var.root_volume_size_gb
    delete_on_termination = true
  }

  user_data = templatefile("${path.module}/cmangos-bootstrap.tftpl", {
    bucket          = var.cmangos_bucket
    config_version  = var.config_version
    client_key      = var.client_key
    extracted_key   = var.extracted_key
    rds_endpoint    = aws_db_instance.cmangos.address
    rds_port        = aws_db_instance.cmangos.port
    public_ip       = aws_eip.cmangos.public_ip
    rds_master_user = var.db_username
    rds_master_pass = var.db_password
  })

  tags = {
    Name = "cmangos-ec2"
  }
}
