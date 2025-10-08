variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "Public subnet CIDR"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_cidr_2" {
  description = "Second public subnet CIDR"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_cidr_1" {
  description = "First private subnet CIDR"
  type        = string
  default     = "10.0.11.0/24"
}

variable "private_subnet_cidr_2" {
  description = "Second private subnet CIDR"
  type        = string
  default     = "10.0.12.0/24"
}

variable "instance_type_bastion" {
  description = "Instance type for bastion"
  type        = string
  default     = "t2.micro"
}

variable "instance_type_app" {
  description = "Instance type for private app"
  type        = string
  default     = "t2.micro"
}

variable "my_ip_cidr" {
  description = "Your IP in CIDR form for SSH access to bastion (set to x.x.x.x/32). Default 0.0.0.0/0 — change this!"
  type        = string
  default     = "0.0.0.0/0"
}

variable "ssh_key_name" {
  description = "Name of the key-pair to create in AWS"
  type        = string
  default     = "local_tls_key.pem"
}