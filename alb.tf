# Security group for ALB: allow inbound HTTP from anywhere
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow HTTP inbound"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP from anywhere"
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

  tags = { Name = "alb-sg" }
}

# Create Application Load Balancer in public subnet
resource "aws_lb" "web_alb" {
  name               = "web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id
  ]

  enable_deletion_protection = false

  tags = { Name = "web-alb" }
}

# Target group for private EC2
resource "aws_lb_target_group" "web_tg" {
  name     = "web-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = { Name = "web-tg" }
}

# Listener for ALB
resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}

# Register private EC2 with target group
resource "aws_lb_target_group_attachment" "web_ec2_attachment1" {
  target_group_arn = aws_lb_target_group.web_tg.arn
  target_id        = aws_instance.private_ec2_1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "web_ec2_attachment2" {
  target_group_arn = aws_lb_target_group.web_tg.arn
  target_id        = aws_instance.private_ec2_2.id
  port             = 80
}