output "ssh_user" {
  value = "ubuntu" # Ubuntu AMI default user
}

output "alb_dns_name" {
  description = "Public DNS of the Application Load Balancer"
  value       = aws_lb.web_alb.dns_name
}