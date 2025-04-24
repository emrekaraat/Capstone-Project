resource "aws_subnet" "capstone_private_1" {
  vpc_id                  = aws_vpc.capstone.id
  cidr_block              = "10.0.10.0/24"  # Updated
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = false

  tags = {
    Name = "capstone-private-subnet-1"
  }
}

resource "aws_subnet" "capstone_private_2" {
  vpc_id                  = aws_vpc.capstone.id
  cidr_block              = "10.0.11.0/24"  # Updated
  availability_zone       = "us-west-2b"
  map_public_ip_on_launch = false

  tags = {
    Name = "capstone-private-subnet-2"
  }
}
