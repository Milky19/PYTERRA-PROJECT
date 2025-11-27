
provider "aws" {
region = "us-east-1"
}

resource "aws_instance" "one" {
  ami             = "ami-0fa3fe0fa7920f68e"
  instance_type   = "t3.micro"
  key_name        = "NEXUS"
  vpc_security_group_ids = [aws_security_group.five.id]
  availability_zone = "us-east-1a"
  user_data       = <<EOF
#!/bin/bash
sudo -i
yum install httpd -y
systemctl start httpd
chkconfig httpd on
echo "Hi all this is my app created by terraform infrastructurte by pythonlife devops krishna sir server-1" > /var/www/html/index.html
EOF
  tags = {
    Name = "web-server-1"
  }
}

resource "aws_instance" "two" {
  ami             = "ami-0fa3fe0fa7920f68e"
  instance_type   = "t3.micro"
  key_name        = "NEXUS"
  vpc_security_group_ids = [aws_security_group.five.id]
  availability_zone = "us-east-1b"
  user_data       = <<EOF
#!/bin/bash
sudo -i
yum install httpd -y
systemctl start httpd
chkconfig httpd on
echo "HIII all this is my website created by terraform infrastructurte by Pythonlife Krishna sir server-2" > /var/www/html/index.html
EOF
  tags = {
    Name = "web-server-2"
  }
}

resource "aws_instance" "three" {
  ami             = "ami-0fa3fe0fa7920f68e"
  instance_type   = "t3.micro"
  key_name        = "NEXUS"
  vpc_security_group_ids = [aws_security_group.five.id]
  availability_zone = "us-east-1a"
  tags = {
    Name = "app-server-1"
  }
}

resource "aws_instance" "four" {
  ami             = "ami-0fa3fe0fa7920f68e"
  instance_type   = "t3.micro"
  key_name        = "NEXUS"
  vpc_security_group_ids = [aws_security_group.five.id]
  availability_zone = "us-east-1b"
  tags = {
    Name = "app-server-2"
  }
}

resource "aws_security_group" "five" {
  name = "elb-sg"
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

resource "aws_iam_user" "seven" {
for_each = var.user_names
name = each.value
}

variable "user_names" {
description = "*"
type = set(string)
default = ["milky", "tillu", "hari", "Dharani"]
}

resource "aws_ebs_volume" "eight" {
 availability_zone = "us-east-1a"
  size = 25
  tags = {
    Name = "ebs-001"
  }
}


