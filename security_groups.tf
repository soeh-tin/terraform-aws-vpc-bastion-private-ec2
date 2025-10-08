# Bastion SG: allow SSH from my IP only
resource "aws_security_group" "bastion_host_sg" {
  name        = "bastion-host-sg"
  description = "Allow SSH from my IP"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "SSH from my IP"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.my_ip_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "bastion-host-sg" }
}

# Private app SG: allow SSH from bastion SG and allow HTTP from within VPC (optional)
resource "aws_security_group" "app_sg" {
  name        = "app-sg"
  description = "Allow SSH from bastion and web traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH from bastion"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.bastion_host_sg.id]
  }

  #ingress {
  #  description = "Allow ICMP ping within VPC"
  #  from_port   = -1
  #  to_port     = -1
  #  protocol    = "icmp"
  #  cidr_blocks = [var.vpc_cidr]
  #}

  ingress {
    description = "HTTP access to Web Server"
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

  tags = { Name = "app-sg" }
}