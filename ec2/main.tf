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

  # Allow all outbound requests on all protocols
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# allow ec2 instance access to ssm and ec2 services
resource "aws_iam_role" "my_ec2_ssm_role" {
  name = "my_ec2_ssm_role"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
              "Service": [
                "ec2.amazonaws.com",
                "ssm.amazonaws.com"
              ]
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_my_ec2_ssm_role" {
  # policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = "${aws_iam_role.my_ec2_ssm_role.name}"
}

resource "aws_iam_instance_profile" "my_ssm_instance_profile" {
    name = "my_ssm_instance_profile"
    role = "${aws_iam_role.my_ec2_ssm_role.name}"
}

# ubuntu
resource "aws_instance" "my-instance-ubuntu" {
  ami           = var.ami_ubuntu
  instance_type = var.instance_type
  associate_public_ip_address = true

  tags = {
    Name = "my-instance-ubuntu"
  }

  key_name = var.ssh_key_name
  vpc_security_group_ids = [ aws_security_group.allow-ssh-inbound.id ]
  iam_instance_profile = aws_iam_instance_profile.my_ssm_instance_profile.name
}

# amazon-linux
resource "aws_instance" "my-instance-amazon-linux" {
  ami           = var.ami_amazon_linux
  instance_type = var.instance_type
  associate_public_ip_address = true

  tags = {
    Name = "my-instance-amazon-linux"
  }

  key_name = var.ssh_key_name
  vpc_security_group_ids = [ aws_security_group.allow-ssh-inbound.id ]
  iam_instance_profile = aws_iam_instance_profile.my_ssm_instance_profile.name
}
