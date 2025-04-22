resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "capstone-nat-eip"
  }
}

resource "aws_eip" "bastion_eip" {
  domain = "vpc"
  tags = {
    Name = "bastion-eip"
  }
}
