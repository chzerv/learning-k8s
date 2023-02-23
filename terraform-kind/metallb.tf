resource "kubernetes_namespace" "metallb_system" {
  metadata {
    name = "metallb-system"
    labels = {
      "pod-security.kubernetes.io/audit"   = "privileged"
      "pod-security.kubernetes.io/enforce" = "privileged"
      "pod-security.kubernetes.io/warn"    = "privileged"
    }
  }
}
#
# https://github.com/hashicorp/terraform-provider-kubernetes/issues/1380#issuecomment-967022975
resource "helm_release" "metallb" {
  name       = "metallb"
  repository = "https://metallb.github.io/metallb"
  chart      = "metallb"

  namespace = kubernetes_namespace.metallb_system.metadata[0].name

  provisioner "local-exec" {
    command = "echo 'Waiting for all the MetalLB pods to be ready ...' && sleep 30"
  }
}

resource "kubectl_manifest" "L2Advertisement" {
  depends_on = [helm_release.metallb]

  yaml_body = <<YAML
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: empty
  namespace: ${kubernetes_namespace.metallb_system.metadata[0].name}
YAML
}

# TODO: Dynamically find out the IP range of the "kind" docker network
resource "kubectl_manifest" "IPAddressPool" {
  depends_on = [helm_release.metallb]

  yaml_body = <<YAML
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: address-pool
  namespace: ${kubernetes_namespace.metallb_system.metadata[0].name}
spec:
  addresses:
    - 172.18.0.0-172.18.0.1
YAML
}
