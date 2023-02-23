terraform {
  required_providers {
    null = {
      source = "hashicorp/null"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    helm = {
      source = "hashicorp/helm"
    }
    kubectl = {
      source = "gavinbunney/kubectl"
    }
    kind = {
      source = "tehcyx/kind"
    }
  }
}

provider "kind" {}

provider "kubernetes" {
  host                   = local.host
  client_certificate     = local.client_cert
  client_key             = local.client_key
  cluster_ca_certificate = local.cluster_cert
}

provider "helm" {
  kubernetes {
    host                   = local.host
    client_certificate     = local.client_cert
    client_key             = local.client_key
    cluster_ca_certificate = local.cluster_cert
  }
}

provider "kubectl" {
  host                   = local.host
  cluster_ca_certificate = local.cluster_cert
}
