output "instance_ip" {
  description = "The public ip for ssh access"
  value       = aws_instance.my-instance.public_ip
}
