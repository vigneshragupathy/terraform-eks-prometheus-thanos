# Terraform file to deploy thanos querier service

data "kubectl_file_documents" "thanosquerierservice" {
  content = file("${path.module}/thanos-querier-service.yaml")
}

resource "kubectl_manifest" "thanosquerierservice" {
    yaml_body = <<YAML
    apiVersion: v1
    kind: Service
    metadata:
      name: thanos-querier
      namespace: monitoring
      labels:
        app: thanos-querier
    spec:
      type: ClusterIP
      ports:
      - name: http
        port: 9090
        targetPort: http
      selector:
        app: thanos-querier
    YAML
}
