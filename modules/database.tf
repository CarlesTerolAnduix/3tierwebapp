# DATABASE RESOURCES

resource "aws_db_instance" "webserver_db" {
  identifier                  = "webserver-db-${var.env}"
  allocated_storage           = 20
  engine                      = "mysql"
  engine_version              = "8.0"
  instance_class              = "db.t3.micro"
  db_name                     = "webappdb${var.env}"
  username                    = "admin"
  manage_master_user_password = true
  # iam_database_authentication_enabled = true

  multi_az                = var.multi_az
  deletion_protection     = var.deletion_protection
  backup_retention_period = var.backup_retention_period
  storage_encrypted       = true

  db_subnet_group_name   = aws_db_subnet_group.webserver_db.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  publicly_accessible    = false
  skip_final_snapshot    = true
}

resource "aws_db_subnet_group" "webserver_db" {
  name       = "webserver-db-subnet-group-${var.env}"
  subnet_ids = [aws_subnet.db_a.id, aws_subnet.db_b.id]

  tags = {
    Name = "webserver-db-subnet-group-${var.env}"
  }
}
