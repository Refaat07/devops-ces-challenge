# ArgoCD Helm release
resource "helm_release" "argocd" {
  name             = "argocd"
  namespace        = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  atomic           = true
  cleanup_on_fail  = true
  version          = "9.4.3" # Specify a consistent version
  create_namespace = true
  # You can set other values here, e.g., for LoadBalancer exposure
#   set {
#     name  = "server.service.type"
#     value = "LoadBalancer"
#   }
  values = [
    templatefile("${path.module}/values.yaml", {
    client_id = var.client_id
    client_secret = var.client_secret
    })
  ]
}

# Datavisyn ArgoCD Application
resource "kubernetes_manifest" "argocd_application" {
  manifest = yamldecode(file("${path.module}/dv-app.yaml"))
  depends_on = [ helm_release.argocd ]
}