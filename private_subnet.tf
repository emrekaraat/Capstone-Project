resource "aws_subnet" "capstone_private_1" {
  vpc_id                  = aws_vpc.capstone.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = false

  tags = {
    Name = "capstone-private-subnet-1"
  }
}

resource "aws_subnet" "capstone_private_2" {
  vpc_id                  = aws_vpc.capstone.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-west-2b"
  map_public_ip_on_launch = false

  tags = {
    Name = "capstone-private-subnet-2"
  }
}
