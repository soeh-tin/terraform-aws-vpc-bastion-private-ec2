output "bastion_host_public_ip" {
  description = "Public IP of bastion host"
  value = aws_instance.bastion_host.public_ip
}

output "ssh_user" {
  value = "ubuntu" # Ubuntu AMI default user
}

output "alb_dns_name" {
  description = "Public DNS of the Application Load Balancer"
  value       = aws_lb.web_alb.dns_name
}