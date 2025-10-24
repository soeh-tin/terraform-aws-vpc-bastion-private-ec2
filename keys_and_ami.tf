# Generate a key locally and upload public to AWS
resource "tls_private_key" "tls_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key_pair" {
  key_name   = var.ssh_key_name
  public_key = tls_private_key.tls_key.public_key_openssh
}

# Save the private key locally so you can SSH later
resource "local_file" "local_tls_key" {
  content  = tls_private_key.tls_key.private_key_pem
  filename = "D:/08_GitHub_Repository_Testing/terraform-aws-vpc-bastion-private-ec2/local_tls_key.pem" # change your folder path in your local PC.
  file_permission = "0600"
}

# Find latest Ubuntu 24.04 LTS AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Amazon

  filter {
    name   = "name"
    values  = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-20250821"]
  }
}