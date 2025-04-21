resource "aws_subnet" "capstone_public" {
  vpc_id            = aws_vpc.capstone.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "capstone-public-subnet"
  }
}