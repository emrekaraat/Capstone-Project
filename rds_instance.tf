resource "aws_db_instance" "capstone_rds" {
  identifier              = "capstone-rds"                       # Unique name for the DB instance
  engine                  = "mariadb"                            # Use MariaDB engine
  engine_version          = "10.5.25"                            # Specific engine version
  instance_class          = "db.t3.micro"                        # Instance type (Free Tier eligible)
  allocated_storage       = 20                                   # Storage size in GB
  storage_type            = "gp2"                                # General purpose SSD
  db_name                 = var.db_name                          # DB name from variables
  username                = var.db_user                          # Master username
  password                = var.db_user_password                 # Master password
  publicly_accessible     = false                                # Keep DB private
  skip_final_snapshot     = true                                 # Don’t create snapshot on deletion
  vpc_security_group_ids  = [aws_security_group.capstone_rds_sg.id] # Attach SG to allow traffic from EC2
  db_subnet_group_name    = aws_db_subnet_group.capstone_subnet_group.name # Use 2 private subnets

  multi_az                = true                                 # ✅ Enable automatic failover to standby in another AZ

  tags = {
    Name = "capstone-rds"
  }
}
