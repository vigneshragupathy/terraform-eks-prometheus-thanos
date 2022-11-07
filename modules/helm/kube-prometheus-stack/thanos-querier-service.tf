# Terraform file to deploy thanos querier service

data "kubectl_file_documents" "thanosquerierservice" {
  content = file("${path.module}/thanos-querier-service.yaml")
}

resource "kubectl_manifest" "thanosquerierservice" {
    yaml_body = <<YAML
    ${data.kubectl_file_documents.thanosquerierservice.documents[0]}
    YAML
}