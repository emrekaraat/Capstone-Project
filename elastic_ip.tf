resource "aws_eip" "nat_eip" {
  vpc = true

  tags = {
    Name = "capstone-nat-eip"
  }
}
