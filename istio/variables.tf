variable "region" {
  default = "us-east-1"
}

variable "remote_state_bucket" {
  default = "wingerts-tfstate-1709"
}

variable "remote_state_key" {
  default = "eks/terraform.tfstate"
}
