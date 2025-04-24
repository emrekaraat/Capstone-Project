resource "aws_db_instance" "capstone_rds" {
  identifier              = "capstone-rds"
  engine                  = "mariadb"
  engine_version          = "10.5.25"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  storage_type            = "gp2"
  db_name                 = var.db_name
  username                = var.db_user
  password                = var.db_user_password
  publicly_accessible     = false
  skip_final_snapshot     = true
  vpc_security_group_ids  = [aws_security_group.capstone_rds_sg.id]
  db_subnet_group_name    = aws_db_subnet_group.capstone_subnet_group.name

  tags = {
    Name = "capstone-rds"
  }
}
