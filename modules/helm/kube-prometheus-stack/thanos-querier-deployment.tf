# Terraform file to deploy thanos querier deployment

data "kubectl_file_documents" "thanosquerierdeployment" {
  content = file("${path.module}/thanos-querier-deployment.yaml")
}

resource "kubernetes_manifest" "thanosquerierdeployment" {
  yaml_body = yamldecode(data.kubectl_file_documents.thanosquerierdeployment.documents[0])
}