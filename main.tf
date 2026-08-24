provider "aws" {
  region = "us-east-1"
}

# Default VPC
data "aws_vpc" "default" {
  default = true
}

# Default Subnets
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Security Group
resource "aws_security_group" "five" {
  name = "alb-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Web Server 1
resource "aws_instance" "one" {
  ami                    = "ami-0332d564d76dbd8d6"
  instance_type          = "t3.micro"
  key_name               = "APP-LB"
  availability_zone      = "us-east-1a"
  vpc_security_group_ids = [aws_security_group.five.id]

  user_data = <<EOF
#!/bin/bash
yum install httpd -y
systemctl start httpd
systemctl enable httpd
echo "Welcome to Web Server 1" > /var/www/html/index.html
EOF

  tags = {
    Name = "web-server-1"
  }
}

# Web Server 2
resource "aws_instance" "two" {
  ami                    = "ami-0332d564d76dbd8d6"
  instance_type          = "t3.micro"
  key_name               = "APP-LB"
  availability_zone      = "us-east-1b"
  vpc_security_group_ids = [aws_security_group.five.id]

  user_data = <<EOF
#!/bin/bash
yum install httpd -y
systemctl start httpd
systemctl enable httpd
echo "Welcome to Web Server 2" > /var/www/html/index.html
EOF

  tags = {
    Name = "web-server-2"
  }
}

output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}
