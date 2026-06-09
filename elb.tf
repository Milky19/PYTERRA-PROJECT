# Application Load Balancer
resource "aws_lb" "alb" {
  name               = "pythonlife-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.five.id]
  subnets            = data.aws_subnets.default.ids

  tags = {
    Name = "pythonlife-alb"
  }
}

# Target Group
resource "aws_lb_target_group" "tg" {
  name     = "pythonlife-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
  }

  tags = {
    Name = "pythonlife-target-group"
  }
}

# Attach Instance 1
resource "aws_lb_target_group_attachment" "server1" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.one.id
  port             = 80
}

# Attach Instance 2
resource "aws_lb_target_group_attachment" "server2" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.two.id
  port             = 80
}

# Listener
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}
