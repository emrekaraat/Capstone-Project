resource "aws_instance" "capstone" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.capstone_public.id
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.capstone_sg.id]
  associate_public_ip_address = true

  user_data = file("user_data.sh")

  tags = {
    Name = "capstone-ec2"
  }
}