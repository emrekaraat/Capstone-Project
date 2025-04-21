resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.capstone.id

  tags = {
    Name = "capstone-private-rt"
  }
}

resource "aws_route_table_association" "private_route_table_assoc" {
  subnet_id      = aws_subnet.capstone_private.id
  route_table_id = aws_route_table.private_route_table.id
}
