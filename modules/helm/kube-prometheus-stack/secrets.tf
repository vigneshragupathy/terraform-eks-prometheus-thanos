#Kubernetes secret for thanos object storage from file thanos-object-storage.yaml
resource "kubernetes_secret" "generic" {
  metadata {
    name      = "thanos-object-storage"
    namespace = var.namespace
  }
  data = {
    "thanos.yaml" = file("${path.module}/thanos-object-storage.yaml")
  }
}