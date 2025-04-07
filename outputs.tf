
#####################################
# EIP Public IP Output
#####################################

output "public_ip" {
  value = "https://${aws_eip.eip.public_ip}:8080"
}