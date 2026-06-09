
provider "aws" {
region = "us-east-1"
}
resource "aws_instance" "one" {
  ami                    = "ami-0152204c1a187337c"
  instance_type          = "t3.micro"
  key_name               = "DOCKER"
  vpc_security_group_ids = [aws_security_group.five.id]
  availability_zone      = "us-east-1a"

  user_data = <<EOF
#!/bin/bash
yum install httpd -y
systemctl start httpd
systemctl enable httpd
echo "This is my app created by Terraform - Server 1" > /var/www/html/index.html
EOF

  tags = {
    Name = "web-server-1"
  }
}

resource "aws_instance" "two" {
  ami                    = "ami-0152204c1a187337c"
  instance_type          = "t3.micro"
  key_name               = "DOCKER"
  vpc_security_group_ids = [aws_security_group.five.id]
  availability_zone      = "us-east-1b"

  user_data = <<EOF
#!/bin/bash
yum install httpd -y
systemctl start httpd
systemctl enable httpd
echo "This is my app created by Terraform - Server 2" > /var/www/html/index.html
EOF

  tags = {
    Name = "web-server-2"
  }
}

resource "aws_instance" "three" {
  ami                    = "ami-0152204c1a187337c"
  instance_type          = "t3.micro"
  key_name               = "DOCKER"
  vpc_security_group_ids = [aws_security_group.five.id]
  availability_zone      = "us-east-1a"

  tags = {
    Name = "app-server-1"
  }
}

resource "aws_instance" "four" {
  ami                    = "ami-0152204c1a187337c"
  instance_type          = "t3.micro"
  key_name               = "DOCKER"
  vpc_security_group_ids = [aws_security_group.five.id]
  availability_zone      = "us-east-1b"

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

resource "aws_ebs_volume" "eight" {
  availability_zone = "us-east-1a"
  size              = 25

  tags = {
    Name = "ebs-001"
  }
}

