# Terraform file to deploy thanos querier service

/*data "kubectl_file_documents" "thanosquerierservice" {
  content = file("${path.module}/thanos-querier-service.yaml")
}

resource "kubernetes_manifest" "thanosquerierservice" {
  for_each = toset(data.kubectl_file_documents.thanosquerierservice.documents)
  manifest = yamldecode(each.value)
  depends_on = [
    kubernetes_secret.generic,
    helm_release.prometheus,
    kubernetes_manifest.thanosquerierdeployment
  ]
}*/