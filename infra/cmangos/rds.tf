resource "aws_db_parameter_group" "cmangos" {
  name   = "cmangos-mysql-params"
  family = var.db_parameter_group_family

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }

  parameter {
    name  = "collation_server"
    value = "utf8mb4_unicode_ci"
  }

  tags = { Name = "cmangos-mysql-params" }
}

resource "aws_db_instance" "cmangos" {
  identifier = "cmangos-mysql"

  engine         = "mysql"
  engine_version = var.db_engine_version

  instance_class = var.db_instance_class

  allocated_storage     = var.db_allocated_storage_gb
  max_allocated_storage = var.db_max_allocated_storage_gb
  storage_type          = "gp3"
  storage_encrypted     = true

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  port = 3306

  db_subnet_group_name   = aws_db_subnet_group.cmangos.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  publicly_accessible    = false

  availability_zone = var.az_b
  multi_az          = false

  parameter_group_name = aws_db_parameter_group.cmangos.name

  # This disables backups and deletion safeguards for PoC
  # Enable retention + protection before any persistent deployment.
  backup_retention_period = 0
  deletion_protection     = false
  skip_final_snapshot     = true

  auto_minor_version_upgrade = true
  apply_immediately          = true

  tags = { Name = "cmangos-mysql" }
}
