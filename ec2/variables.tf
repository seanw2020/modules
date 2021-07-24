variable "ssh_key_name" {
  description = "the name of the ssh key"
  type        = string
  default     = "my-ssh-key"
}

variable "ssh_key" {
  description = "ssh key for ec2 access"
  type        = string
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDAiCVBpl4P3ihpltbF+/ab6+gDg8MEdGFUe/0q2tS2cITd6+LPEduW1Oisv8tfUC/KTqyao/Mdxx1gO/O6Eoybbp6HgFiAG8bol573l8QJKIml/1nsvGsCE7MUe1LoZIN1nHxfxALWAO8ZVVmJVN9lhIR40zLikV6e/n7A8Qo2Pmy8bys4mg3k09VT4PbCYye5fuyH+MfJU2Fw1NCUYAsIIuws2lRG10IDB3RY/i2M5LKXtHdRE2xgB11Y4204XBZiYWpng3WZO5ny2rt8p1zabjuQ08D5R2grkTPOgivKS0vb5sQJy/gDDDtIjq0Z69WSsuBahXE1Ddw6pb9/4ZeDBuFadvNRmtxrqs5KlTNzCPV73F+a7tqU5MVEIswbm7hMUuwe5dfbEAisCyivL6m0nHN7rNeNDzSxBkpPplWD+yGpLbRrBo2P5juVm030qWQoZn5F/DYPGhf70PirQncaTIeyjoPghiyROxF8NFyku5eeCAPvmaRsJ2KhNzJ+324FRzXS/UgAKU+K/YTkxLtS7UccISE4vKUw27V4d4lz4SKfgXBHaTNgmmEjngdKFaYb7sbr1Z5d9m7UDsletBb1Exw8UU6JKFggoGpUvVbmOrihsZ7H0VeLWuYbFQ/hJqiBGsGLp6SG+5/Gn+E/CFteGuWLZSvr25dzYbsfVZHfoQ== sean@wsl2"
}

variable "ami_ubuntu" {
  description = "ami to use"
  type        = string
  default     = "ami-042e8287309f5df03"
}

variable "ami_amazon_linux" {
  description = "ami to use"
  type        = string
  default     = "ami-0dc2d3e4c0f9ebd18"
}

variable "instance_type" {
  description = "instance family and size"
  type        = string
  default     = "t2.micro"
}
