# based partly on https://stackoverflow.com/questions/67057466/install-istio-on-eks-cluster-using-terraform-and-helm

# instead of this, use terragrunt which integrates tfenv, tgenv, ,.terraform-version, and .terragrunt-version
# terraform {
#   required_version = ">= 0.12"
# }

# data "aws_eks_cluster" "example" {
#   name = "example"
# }

# data "terraform_remote_state" "eks" {
#   backend = "s3"

#   config = {
#     bucket  = "${var.remote_state_bucket}"
#     region  = "${var.region}"
#     key     = "${var.remote_state_key}"
#   }
# }

terraform {
  required_version = ">= 0.13.1"

  required_providers {
    aws        = ">= 3.22.0"
    kubernetes = "~> 1.11"
    helm       = ">= 2.2.0"
  }
}

# output "foo" {
#   #value = data.aws_eks_cluster.example
#   # value = data.terraform_remote_state.eks.outputs.cluster_id
#   value = data.aws_eks_cluster.cluster
# }

data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    args = ["eks", "get-token", "--cluster-name", var.cluster_name]
    command = "aws"
  }
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
      command     = "aws"
    }
  }
}

# provider "helm" {
#   kubernetes {
#     host                   = data.terraform_remote_state.eks.outputs.cluster_endpoint
#     cluster_ca_certificate = data.terraform_remote_state.eks.outputs.cluster_id
#     exec {
#       api_version = "client.authentication.k8s.io/v1alpha1"
#       args        = ["eks", "get-token", "--cluster-name", data.terraform_remote_state.eks.outputs.cluster_id]
#       command     = "aws"
#     }
#   }
# }

# resource "kubernetes_namespace" "istio-system" {
#   metadata {
#     annotations = {
#       name = "istio-system"
#     }

#     labels = {
#       mylabel = "istio-system"
#     }

#     name = "istio-system"
#   }
# }

resource "kubernetes_namespace" "istioinaction" {
  metadata {
    annotations = {
      name = "istioinaction"
    }

    labels = {
      mylabel = "istioinaction"
    }

    name = "istioinaction"
  }
}

resource "helm_release" "istio_base" {
  name       = "istio-base"
  chart      = "release/manifests/charts/base"
  namespace  = "istio-system"
  create_namespace = true
}

resource "helm_release" "istiod" {
  name       = "istiod"
  chart      = "release/manifests/charts/istio-control/istio-discovery"
  namespace  = "istio-system"
  create_namespace = true
}

resource "helm_release" "istio-ingress" {
  name       = "istio-ingress"
  chart      = "release/manifests/charts/gateways/istio-ingress"
  namespace  = "istio-system"
  create_namespace = true
}

resource "helm_release" "istio-egress" {
  name       = "istio-egress"
  chart      = "release/manifests/charts/gateways/istio-egress"
  create_namespace = true
}

# resource "aws_iam_role" "eksproject-cluster" {
#   name = "terraform-eks-eksproject-cluster"

# assume_role_policy = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "eks.amazonaws.com"
#       },
#       "Action": "sts:AssumeRole"
#     }
#   ]
# }
# POLICY
# }
