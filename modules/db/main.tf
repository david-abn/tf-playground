resource "aws_db_subnet_group" "main" {
  name       = "${var.env}-db-subnet-group"
  subnet_ids = var.private_subnet_ids
}

resource "aws_db_instance" "main" {
  identifier             = "${var.env}-postgres"
  engine                 = "postgres"
  engine_version         = "16.3"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  storage_type           = "gp3"
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.db_sg_id]
  skip_final_snapshot    = true
  publicly_accessible    = false

  tags = {
    Name = "${var.env}-postgres"
  }
}
