# Bastion host in public subnet
resource "aws_instance" "bastion_host" {
  ami                    = data.aws_ami.ubuntu.id # Ubuntu Noble 24.04 AMI (change based on region)
  instance_type          = var.instance_type_bastion
  subnet_id              = aws_subnet.public_1.id
  vpc_security_group_ids = [aws_security_group.bastion_host_sg.id]
  key_name               = aws_key_pair.key_pair.key_name
  associate_public_ip_address = true

  tags = { Name = "bastion-host" }

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get upgrade -y
              EOF
}

# First private EC2 (in subnet1)
resource "aws_instance" "private_ec2_1" {
  ami                    = data.aws_ami.ubuntu.id # Ubuntu Noble 24.04 AMI (change based on region)
  instance_type          = var.instance_type_app
  subnet_id              = aws_subnet.private_1.id
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  key_name               = aws_key_pair.key_pair.key_name
  associate_public_ip_address = false

  tags = { Name = "private-ec2-1" }

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y nginx
              systemctl enable nginx
              systemctl start nginx

              echo "<html><body><h1>Private Ubuntu 24.04 Web Server on $(hostname -I) from Soe San</h1></body></html>" > /var/www/html/index.html
              EOF
}

# Second private EC2 (in subnet2)
resource "aws_instance" "private_ec2_2" {
  ami                    = data.aws_ami.ubuntu.id # Ubuntu Noble 24.04 AMI (change based on region)
  instance_type          = var.instance_type_app
  subnet_id              = aws_subnet.private_2.id
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  key_name               = aws_key_pair.key_pair.key_name
  associate_public_ip_address = false

  tags = { Name = "private-ec2-2" }

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y nginx
              systemctl enable nginx
              systemctl start nginx

              echo "<html><body><h1>Private Ubuntu 24.04 Web Server 2 on $(hostname -I) from Soe San</h1></body></html>" > /var/www/html/index.html
              EOF
}