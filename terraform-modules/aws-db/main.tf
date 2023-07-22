resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = var.public_subnet_ids
}

resource "aws_db_instance" "rds_instance" {
  allocated_storage         = var.db_storage_size
  storage_type              = var.db_storage_type
  engine                    = var.db_engine_type
  engine_version            = var.db_engine_version
  instance_class            = var.db_instance_class
  db_name                   = var.db_name
  username                  = var.db_username
  password                  = var.db_password
  skip_final_snapshot       = true
  publicly_accessible       = true
  db_subnet_group_name      = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids    = [var.security_group_id]

  depends_on = [aws_db_subnet_group.rds_subnet_group]
}