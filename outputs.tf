
#####################################
# EIP Public IP Output
#####################################

output "app_url" {
  value = "https://${aws_lb.alb.dns_name}"
  description = "URL used to access the application"
}

output "vpc_id" {
  value = aws_vpc.main.id
}