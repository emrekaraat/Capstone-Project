resource "aws_db_subnet_group" "capstone_subnet_group" {
  name       = "capstone-subnet-group"
  subnet_ids = [aws_subnet.capstone_private.id]

  tags = {
    Name = "capstone-rds-subnet-group"
  }
}
