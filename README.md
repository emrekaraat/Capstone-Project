# Capstone-Project  
AWS Project with WordPress as a Webserver, Auto Scaling, and ALB

# Capstone AWS Project – WordPress Infrastructure

This project provisions a fully functional, highly available WordPress environment on AWS using Terraform. The architecture includes secure networking, automated scaling, logging, and modular Infrastructure as Code (IaC) practices.

---

## ✅ Key Features

- 🖧 **Networking**: Custom VPC with 2 public and 2 private subnets across two Availability Zones (AZs).
- 🛡️ **Security**:
  - Dedicated Security Groups for Bastion Host, ALB, RDS, and Auto Scaling EC2s
  - Ingress/Egress rules scoped to minimum required access
- 🚀 **Compute**:
  - Bastion Host in Public Subnet (SSH Access)
  - EC2 Instances in Private Subnets via Auto Scaling Group
  - Launch Template with `user_data` for WordPress installation
- 🗄️ **Database**: 
  - Amazon RDS (MariaDB) with Multi-AZ enabled for automatic failover
  - Primary DB and Standby DB spread across private subnets in different AZs
- 🌐 **Load Balancer**: Application Load Balancer (ALB) exposes WordPress to the internet over HTTP (Port 80).
- 📈 **Monitoring**:
  - Amazon CloudWatch Alarm based on EC2 CPU Utilization
  - SNS Email notifications for scale-out events
  - Log groups disabled during testing due to EC2 limits (Vocareum sandbox)
- 📦 **Automation**:
  - Auto Scaling based on CPU threshold (scale-out & scale-in)
  - Fully automated provisioning via `terraform apply`
- 🛡️ **Logging & Auditing**:
  - **AWS CloudTrail** is enabled to log all API calls and user activity
  - Logs are stored securely in an S3 bucket with file integrity validation
  - Global service events (e.g., IAM) are included

---

## 📂 File Structure

- `main.tf`, `provider.tf`: Terraform provider and region setup
- `auto_scaling.tf`: Launch Template, ASG configuration, and scaling policies
- `asg_sg.tf`: Security Group for Auto Scaling EC2 instances ✅
- `alb.tf`: Application Load Balancer & Target Group
- `bastion_host.tf`, `connect_to_private_ec2.sh`: Bastion access
- `rds_instance.tf`: RDS MariaDB setup with Multi-AZ
- `rds_security_group.tf`: SG allowing EC2 to connect to RDS (port 3306)
- `cloudwatch_alarm.tf`: CloudWatch alarm and SNS topic
- `user_data.sh.tpl`: Shell script to install and configure WordPress
- `cloudtrail.tf`: CloudTrail resource definition
- `cloudtrail_s3.tf`: S3 bucket, bucket policy, ACL, and random suffix for CloudTrail logs

---

## 🌐 Access

- **WordPress Public URL** (via ALB):  
  http://capstone-alb-1540634271.us-west-2.elb.amazonaws.com  
  (*Note: This URL may change with each Terraform deployment.*)

---

## 📬 Email Alerts

- CloudWatch Alarm triggers when EC2 CPU > 70%
- Email notifications sent via AWS SNS Topic

---

## 🧠 Technical Notes

- **Multi-AZ RDS:**  
  `multi_az = true` enables high availability. AWS maintains a standby DB in another AZ. Failover happens automatically.
  
- **Modular Security Groups:**  
  EC2s in ASG are now isolated via `asg_sg`, which only allows what’s necessary (e.g., access to RDS).

- **ALB & EC2 Routing:**  
  ALB routes HTTP traffic to EC2 instances behind the scenes using a target group.

- **CloudTrail & Auditing:**
  CloudTrail logs all API activity into a versioned S3 bucket, enabling full visibility into actions performed in the AWS account.

---

## 🧩 Update Note – Dedicated SG for ASG EC2s

A new security group `asg_sg` was created for Auto Scaling Group instances. This improves isolation, restricts RDS access only to valid EC2s, and makes future scaling or service integration easier.

---

## 🛠️ Future Work

- ✅ **WordPress Customization:**  
  Add themes, plugins, and personal content (CV, portfolio, or football blog)

- 🌍 **Domain & SSL:**  
  Integrate with Route53 and ACM for HTTPS and custom domain

- ☁️ **Optional Services:**
  - Amazon S3 for media storage (not needed yet)
  - AWS CloudFront for CDN & faster delivery
  - CloudWatch Logs (requires IAM permission)
  - CloudWatch Dashboard
