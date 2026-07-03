resource "kubernetes_manifest" "app" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "my-workload"
      namespace = "argocd"
    }
    spec = {
      project = "default"
      source = {
        repoURL = "https://github.com/your/repo.git"
        path    = "apps/my-workload"
        targetRevision = "main"
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "default"
      }
      syncPolicy = {
        automated = {
          prune    = true
          selfHeal = true
        }
      }
    }
  }
}
