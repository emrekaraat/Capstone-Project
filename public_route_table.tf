resource "aws_route_table" "capstone_public" {
  vpc_id = aws_vpc.capstone.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.capstone_igw.id
  }

  tags = {
    Name = "capstone-public-rt"
  }
}

resource "aws_route_table_association" "capstone_public_assoc" {
  subnet_id      = aws_subnet.capstone_public.id
  route_table_id = aws_route_table.capstone_public.id
}