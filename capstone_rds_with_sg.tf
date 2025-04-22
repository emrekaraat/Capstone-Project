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
}

resource "aws_security_group" "capstone_rds_sg" {
  name        = "capstone-rds-sg"
  description = "Allow MySQL from private EC2"
  vpc_id      = aws_vpc.capstone_vpc.id

  ingress {
    description = "MySQL from private EC2"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.capstone_sg.id] # EC2'nin SG’si
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "capstone-rds-sg"
  }
}

resource "aws_db_subnet_group" "capstone_subnet_group" {
  name       = "capstone-subnet-group"
  subnet_ids = [aws_subnet.capstone_private.id]

  tags = {
    Name = "capstone-rds-subnet-group"
  }
}
