# "kubectl" is not a terraform provider, which means it cannot be inherited from the root module.
terraform {
  required_providers {
    kubectl = {
      source = "gavinbunney/kubectl"
    }
  }
}

provider "kubectl" {
  host                   = var.host
  cluster_ca_certificate = var.cluster_cert
}
