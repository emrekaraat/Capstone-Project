resource "aws_subnet" "capstone_private" {
  vpc_id                  = aws_vpc.capstone.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = false

  tags = {
    Name = "capstone-private-subnet"
  }
}
