resource "aws_internet_gateway" "capstone_igw" {
  vpc_id = aws_vpc.capstone.id

  tags = {
    Name = "capstone-igw"
  }
}