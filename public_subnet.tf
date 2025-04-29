# Public Subnet 1 in us-west-2a
resource "aws_subnet" "capstone_public" {
  vpc_id                  = aws_vpc.capstone.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "capstone-public-subnet-1"
  }
}

# Public Subnet 2 in us-west-2b (new subnet)
resource "aws_subnet" "capstone_public_2" {
  vpc_id                  = aws_vpc.capstone.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-west-2b"
  map_public_ip_on_launch = true

  tags = {
    Name = "capstone-public-subnet-2"
  }
}

# Associate Public Subnet 1 to Public Route Table
resource "aws_route_table_association" "capstone_public_assoc_1" {
  subnet_id      = aws_subnet.capstone_public.id
  route_table_id = aws_route_table.capstone_public.id
}

# Associate Public Subnet 2 to Public Route Table
resource "aws_route_table_association" "capstone_public_assoc_2" {
  subnet_id      = aws_subnet.capstone_public_2.id
  route_table_id = aws_route_table.capstone_public.id
}
