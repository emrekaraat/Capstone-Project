resource "aws_nat_gateway" "capstone_nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.capstone_public.id

  tags = {
    Name = "capstone-nat-gateway"
  }
}
