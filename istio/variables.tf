variable "region" {
  default = "us-east-1"
}

variable "cluster_name" {
  default = "my-cluster"
}

variable "remote_state_bucket" {
  default = "wingerts-tfstate-1709"
}

variable "remote_state_key" {
  default = "eks/terraform.tfstate"
}

variable "role_arn" {
  description = "assume this role when provisioning."
  # something like this:
  # role_arn = "arn:aws:iam::${get_aws_account_id()}:role/terragrunt"
}
