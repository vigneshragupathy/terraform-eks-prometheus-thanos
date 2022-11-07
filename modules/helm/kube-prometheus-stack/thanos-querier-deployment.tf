# Terraform file to deploy thanos querier deployment

data "kubectl_file_documents" "thanosquerierdeployment" {
  content = file("${path.module}/thanos-querier-deployment.yaml")
}

resource "kubectl_manifest" "thanosquerierdeployment" {
  yaml_body = <<YAML
  apiVersion: apps/v1
  kind: Deployment
  metadata:
    name: thanos-querier
    namespace: monitoring
    labels:
      app: thanos-querier
  spec:
    replicas: 1
    selector:
      matchLabels:
        app: thanos-querier
    template:
      metadata:
        labels:
          app: thanos-querier
      spec:
        containers:
        - name: thanos-querier
          image: thanosio/thanos:v0.17.2
          args:
          - query
          - --query.replica-label=prometheus_replica
          - --store=dnssrv+_grpc._tcp.kube-prometheus-stack-prometheus-thanos-discovery.monitoring.svc.cluster.local
          ports:
          - containerPort: 9090
            name: http
          - containerPort: 10901
            name: grpc
  YAML
}
