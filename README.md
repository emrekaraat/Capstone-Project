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
  - Launch Template with user_data for WordPress installation
- 🗄️ **Database**: RDS MariaDB in private subnet.
- 🌐 **Load Balancer**: Application Load Balancer (ALB) forwarding HTTP to EC2.
- 📈 **Monitoring**:
  - CloudWatch Alarm on CPU Utilization
  - SNS Email notifications
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

## ⚠️ Important Note

This project is built and tested on an AWS sandbox environment (Vocareum) with limited IAM permissions.  
Therefore, IAM Role and CloudWatch Log Group resources are intentionally excluded to avoid deployment errors.  
They can be added manually in a full-permission AWS environment.
