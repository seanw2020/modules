output "instance_ip_ubuntu" {
  description = "The public ip for ssh access"
  value       = aws_instance.my-instance-ubuntu.public_ip
}

output "instance_ip_ubuntu_id" {
  description = "The public ip for ssh access"
  value       = aws_instance.my-instance-ubuntu.id
}

output "instance_ip_amazon_linux_id" {
  description = "The public ip for ssh access"
  value       = aws_instance.my-instance-amazon-linux.id
}

output "instance_ip_amazon_linux" {
  description = "The public ip for ssh access"
  value       = aws_instance.my-instance-amazon-linux.public_ip
}

# output "instance_ip_amazon_linux_all" {
#   description = "The public ip for ssh access"
#   value       = aws_instance.my-instance-amazon-linux
# }
