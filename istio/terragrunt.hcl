locals {
  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
}

# include {
#   path = find_in_parent_folders()
# }

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "aws" {
  region         = "${local.common_vars.region}"
  assume_role {
  role_arn = "arn:aws:iam::${get_aws_account_id()}:role/terragrunt"
  }
}
EOF
}

generate "remote_state" {
  path = "data.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
data "terraform_remote_state" "eks" {
  backend = "s3"

  config = {
    bucket  = "${local.common_vars.bucket}"
    region  = "${local.common_vars.region}"
    key     = "${path_relative_to_include()}/../eks/terraform.tfstate"
  }
}
EOF
}
