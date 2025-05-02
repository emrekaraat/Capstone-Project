# Capstone-Project  
AWS Project with WordPress as a Webserver, Auto Scaling, and ALB

# Capstone AWS Project – WordPress Infrastructure

This project provisions a fully functional, scalable WordPress environment on AWS using Terraform.

---

## ✅ Key Features

- 🖧 **Networking**: Custom VPC with public and private subnets across multiple AZs.
- 🛡️ **Security**: Security Groups for Bastion, EC2, and RDS.
- 🚀 **Compute**:
  - Bastion Host (public subnet)
  - EC2 Instances (private subnet) via Auto Scaling Group
  - Launch Template with `user_data` for WordPress installation
- 🗄️ **Database**: RDS MariaDB in private subnet.
- 🌐 **Load Balancer**: Application Load Balancer (ALB) forwarding HTTP to EC2.
- 📈 **Monitoring**:
  - CloudWatch Alarm on CPU Utilization
  - SNS Email notifications
  - Log groups were not activated during testing due to EC2 launch limits (Vocareum’s ASG max size is 6)
- 📦 **Automation**:
  - Auto Scaling (scale-out on high CPU, scale-in after cooldown)
  - Complete infrastructure deployment using Terraform

---

## 📂 File Structure

- `main.tf`, `provider.tf`: Terraform core setup
- `auto_scaling.tf`: ASG, Launch Template, scaling policies
- `user_data.sh.tpl`: WordPress installation on EC2
- `alb.tf`: ALB & target group
- `cloudwatch_alarm.tf`: Alarm for scaling
- `bastion_host.tf`, `connect_to_private_ec2.sh`: Bastion configuration & access
- `rds_instance.tf`: Managed DB setup

---

## 🌐 Access

- **WordPress Public URL**:  
  http://capstone-alb-1540634271.us-west-2.elb.amazonaws.com

---

## 📬 Email Alerts

CloudWatch CPU alarm triggers an SNS email notification when usage is high.

---

## 📚 Reference

Terraform AWS Security Group Resource (latest structure):  
🔗 https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group  
(*I am currently using inline security group rules, but in future iterations I may switch to `aws_vpc_security_group_ingress_rule` and `egress_rule` resources for better modularity and separation of concerns.*)
