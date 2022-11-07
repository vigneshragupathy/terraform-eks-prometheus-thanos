# Terraform file to deploy thanos querier deployment

data "kubectl_file_documents" "thanosquerierdeployment" {
  content = file("${path.module}/thanos-querier-deployment.yaml")
}

resource "kubectl_manifest" "thanosquerierdeployment" {
  yaml_body = <<YAML
  ${data.kubectl_file_documents.thanosquerierdeployment.documents[0]}
  YAML
}