# Generated by Terragrunt. Sig: nIlQXj57tbuaRZEa
terraform {
  backend "s3" {
    bucket         = "wingerts-tfstate-1709"
    dynamodb_table = "my-lock-table"
    encrypt        = true
    key            = "eks/terraform.tfstate"
    region         = "us-east-1"
  }
}
