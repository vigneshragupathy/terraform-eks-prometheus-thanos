# Terraform file to deploy thanos querier deployment

data "kubectl_file_documents" "thanosquerierdeployment" {
  content = file("${path.module}/thanos-querier-deployment.yaml")
}

resource "kubernetes_manifest" "thanosquerierdeployment" {
  for_each = toset(data.kubectl_file_documents.thanosquerierdeployment.documents)
  manifest = yamldecode(each.value)
  depends_on = [
    kubernetes_secret.generic,
    helm_release.prometheus
  ]
}