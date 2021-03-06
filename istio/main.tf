# based partly on https://stackoverflow.com/questions/67057466/install-istio-on-eks-cluster-using-terraform-and-helm

terraform {
  required_version = ">= 0.13.1"

  required_providers {
    aws        = ">= 3.22.0"
    kubernetes = "~> 1.11"
    helm       = ">= 2.2.0"

    kubectl = {
      source = "gavinbunney/kubectl"
      version = ">= 1.11.2"
    }
  }
}

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

resource "helm_release" "istio-operator" {
  name       = "istio-operator"
  # this is a git submodule
  chart      = "release/manifests/charts/istio-operator"
  namespace  = "istio-system"
  create_namespace = true

  values = [
    file("${path.module}/operator.yaml")
  ]
}

# provider "kubectl" {
#   host                   = data.aws_eks_cluster.cluster.endpoint
#   cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
#   exec {
#     api_version = "client.authentication.k8s.io/v1alpha1"
#     args = ["eks", "get-token", "--cluster-name", var.cluster_name]
#     command = "aws"
#   }
# }

# resource "kubectl_manifest" "operator" {
#     yaml_body = file("${path.module}/configure.yaml")
# }
