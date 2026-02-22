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

  values = [
    templatefile("${path.module}/values.yaml", {
    client_id = var.client_id
    client_secret = var.client_secret
    argocd_domain_name = var.argocd_domain_name
    })
  ]
}

# Datavisyn ArgoCD Application
resource "kubernetes_manifest" "argocd_application" {
  manifest = yamldecode(file("${path.module}/dv-app.yaml"))
  depends_on = [ helm_release.argocd ]
}