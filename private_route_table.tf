#creating private_route_table

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.capstone.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.capstone_nat.id
  }

  tags = {
    Name = "capstone-private-rt"
  }
}

resource "aws_route_table_association" "private_route_table_assoc" {
  subnet_id      = aws_subnet.capstone_private.id
  route_table_id = aws_route_table.private_route_table.id
}

