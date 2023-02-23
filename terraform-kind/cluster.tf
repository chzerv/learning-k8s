# If the "cluster_name" variable is not specified, use "kind" as the cluster name
locals {
  cluster_name = var.cluster_name != null ? var.cluster_name : "kind"
}

# Create a 3-node cluster: 1 control-plane node and 2 worker nodes
resource "kind_cluster" "cluster" {
  name = local.cluster_name
  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"
    node {
      role = "control-plane"
    }
    node {
      role = "worker"
    }
    node {
      role = "worker"
    }
  }

  # On destroy, even though the cluster is destroyed, kubeconfig is not cleaned,
  # unless we manually run "kind delete cluster".
  # Not sure if using an on-destroy provisioner is the right solution, but it works, at least for now.
  provisioner "local-exec" {
    when    = destroy
    command = "kind delete cluster --name ${self.name}"
  }
}

locals {
  host         = kind_cluster.cluster.endpoint
  cluster_cert = kind_cluster.cluster.cluster_ca_certificate
  client_cert  = kind_cluster.cluster.client_certificate
  client_key   = kind_cluster.cluster.client_key
}

# A container image can be provided using the '-var image=my-image' option
# If this option is not specified, this resource will be skipped
resource "null_resource" "load_image" {
  count = var.image != "" ? 1 : 0
  provisioner "local-exec" {
    command = "kind load docker-image ${var.image} --name ${kind_cluster.cluster.name}"
  }
}
