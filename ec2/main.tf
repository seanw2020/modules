terraform {
  # required_version = ">= 0.12, < 0.13"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "ssh-key" {
  key_name = var.ssh_key_name
  public_key = var.ssh_key
}

resource "aws_security_group" "allow-ssh-inbound" {
  name = "allow-ssh-inbound"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "my-instance" {
  ami           = var.ami
  instance_type = var.instance_type
  associate_public_ip_address = true

  tags = {
    Name = "my-instance"
  }

  key_name = var.ssh_key_name
  vpc_security_group_ids = [ aws_security_group.allow-ssh-inbound.id ]
}
