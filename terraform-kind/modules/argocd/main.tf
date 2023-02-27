resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

data "http" "argocd-manifest" {
  url = "https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml"
}

data "kubectl_file_documents" "argocd" {
  content = data.http.argocd-manifest.response_body
}

resource "kubectl_manifest" "argocd" {
  for_each           = data.kubectl_file_documents.argocd.manifests
  yaml_body          = each.value
  override_namespace = kubernetes_namespace.argocd.metadata[0].name
}

data "kubernetes_secret" "argocd_initial_admin_password" {
  metadata {
    name      = "argocd-initial-admin-secret"
    namespace = kubernetes_namespace.argocd.metadata[0].name
  }
}

output "argocd_initial_admin_password" {
  value = values(data.kubernetes_secret.argocd_initial_admin_password.data)
}
