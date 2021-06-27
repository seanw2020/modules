data "aws_caller_identity" "current" {}

resource "aws_iam_role" "terragrunt" {
  name       = "terragrunt"
  path               = "/"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/admin",
          "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/cloud_user"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

data "aws_iam_policy" "AdministratorAccess" {
  arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_role_policy_attachment" "terragrunt" {
  role       = aws_iam_role.terragrunt.name
  policy_arn = data.aws_iam_policy.AdministratorAccess.arn
}
