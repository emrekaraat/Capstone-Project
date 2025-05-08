resource "aws_instance" "capstone" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.capstone_private_1.id
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.capstone_sg.id]
  associate_public_ip_address = false

  user_data = templatefile("${path.module}/user_data.sh.tpl", {
    db_root_password   = var.db_root_password
    db_user            = var.db_user
    db_user_password   = var.db_user_password
    db_name            = var.db_name
    db_host            = aws_db_instance.capstone_rds.endpoint
    notification_email = var.notification_email          # ✅ eklendi
  })

  tags = {
    Name = "capstone-ec2"
  }
}
