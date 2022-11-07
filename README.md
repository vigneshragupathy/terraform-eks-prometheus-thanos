# Terraform to deploy kube-prometheus-stack in AWS EKS using Helm chart

This repository is forked from hashicorp/learn-terraform-provision-eks-cluster and modified to deploy kube-prometheus-stack in EKS using Helm chart.

> Note: This repository is only for learning purposes. It is not recommended to use this in production.

## Sample output after terraform apply

```bash
 kubectl get pods -n monitoring                                                                                                           false
NAME                                                     READY   STATUS    RESTARTS      AGE
alertmanager-prometheus-kube-prometheus-alertmanager-0   2/2     Running   0             10m
prometheus-grafana-f69f4c985-lxxjw                       2/2     Running   0             11m
prometheus-kube-prometheus-operator-f5d67844f-p6r24      1/1     Running   0             11m
prometheus-kube-state-metrics-54fb5f89bc-9qbcz           1/1     Running   0             11m
prometheus-prometheus-kube-prometheus-prometheus-0       2/2     Running   1 (10m ago)   10m
prometheus-prometheus-node-exporter-gbn59                1/1     Running   0             11m
prometheus-prometheus-node-exporter-q9lmx                1/1     Running   0             11m
prometheus-prometheus-node-exporter-sqkrb                1/1     Running   0             11m
```

```bash
kubectl get svc -n monitoring                                                                                                            false
NAME                                      TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                      AGE
alertmanager-operated                     ClusterIP   None             <none>        9093/TCP,9094/TCP,9094/UDP   11m
prometheus-grafana                        ClusterIP   172.20.55.103    <none>        80/TCP                       11m
prometheus-kube-prometheus-alertmanager   ClusterIP   172.20.79.198    <none>        9093/TCP                     11m
prometheus-kube-prometheus-operator       ClusterIP   172.20.81.64     <none>        443/TCP                      11m
prometheus-kube-prometheus-prometheus     ClusterIP   172.20.153.95    <none>        9090/TCP                     11m
prometheus-kube-state-metrics             ClusterIP   172.20.240.237   <none>        8080/TCP                     11m
prometheus-operated                       ClusterIP   None             <none>        9090/TCP                     11m
prometheus-prometheus-node-exporter       ClusterIP   172.20.137.255   <none>        9100/TCP                     11m
```

### To port forward prometheus service

```bash
kubectl port-forward svc/prometheus-kube-prometheus-prometheus 9090:9090 -n monitoring                                                   false
Forwarding from 127.0.0.1:9090 -> 9090
Forwarding from [::1]:9090 -> 9090
Handling connection for 9090
Handling connection for 9090
Handling connection for 9090
Handling connection for 9090
```

### To view the Thanos sidecar details

```bash
kubectl describe pod prometheus-prometheus-kube-prometheus-prometheus-0 -n monitoring
```

```bash
  thanos-sidecar:
    Container ID:  docker://3d0c14e1b0f5c5f635b5c598d36e3182d0e31203c9a894fa4d5fa29c7d23bee8
    Image:         quay.io/thanos/thanos:v0.20.2
    Image ID:      docker-pullable://quay.io/thanos/thanos@sha256:0d1390410acade88733b8182e723497448fe0bdcfdfed61864325ad377057f3e
    Ports:         10902/TCP, 10901/TCP
    Host Ports:    0/TCP, 0/TCP
    Args:
      sidecar
      --prometheus.url=http://127.0.0.1:9090/
      --grpc-address=[$(POD_IP)]:10901
      --http-address=[$(POD_IP)]:10902
      --objstore.config=$(OBJSTORE_CONFIG)
      --tsdb.path=/prometheus
      --log.level=info
      --log.format=logfmt
    State:          Running
      Started:      Fri, 04 Nov 2022 22:04:44 +0530
    Ready:          True
    Restart Count:  0
    Environment:
      POD_IP:            (v1:status.podIP)
      OBJSTORE_CONFIG:  <set to the key 'thanos.yaml' in secret 'thanos-object-storage'>  Optional: false
    Mounts:
      /prometheus from prometheus-prometheus-kube-prometheus-prometheus-db (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-n9tdt (ro)
```

### To view the Thanos sidecar logs

```bash
 kubectl logs -f prometheus-prometheus-kube-prometheus-prometheus-0 -n monitoring -c thanos-sidecar                                       false
level=info ts=2022-11-04T16:34:44.811073278Z caller=options.go:23 protocol=gRPC msg="disabled TLS, key and cert must be set to enable"
level=info ts=2022-11-04T16:34:44.811826897Z caller=factory.go:46 msg="loading bucket configuration"
level=error ts=2022-11-04T16:34:44.812198821Z caller=sidecar.go:266 err="WAL dir is not accessible. Is this dir a TSDB directory? If yes it is shared with TSDB?: stat /prometheus/wal: no such file or directory"
level=info ts=2022-11-04T16:34:44.812234094Z caller=sidecar.go:307 msg="starting sidecar"
level=info ts=2022-11-04T16:34:44.812383443Z caller=reloader.go:183 component=reloader msg="nothing to be watched"
level=info ts=2022-11-04T16:34:44.812519858Z caller=intrumentation.go:60 msg="changing probe status" status=healthy
level=info ts=2022-11-04T16:34:44.812560102Z caller=http.go:62 service=http/server component=sidecar msg="listening for requests and metrics" address=[10.0.1.25]:10902
level=info ts=2022-11-04T16:34:44.813128202Z caller=intrumentation.go:48 msg="changing probe status" status=ready
level=info ts=2022-11-04T16:34:44.813167353Z caller=grpc.go:123 service=gRPC/server component=sidecar msg="listening for serving gRPC" address=[10.0.1.25]:10901
level=warn ts=2022-11-04T16:34:44.813294776Z caller=sidecar.go:319 msg="failed to get Prometheus flags. Is Prometheus running? Retrying" err="request config against http://127.0.0.1:9090/api/v1/status/flags: Get \"http://127.0.0.1:9090/api/v1/status/flags\": dial tcp 127.0.0.1:9090: connect: connection refused"
level=info ts=2022-11-04T16:34:46.833577386Z caller=sidecar.go:168 msg="successfully loaded prometheus external labels" external_labels="{prometheus=\"monitoring/prometheus-kube-prometheus-prometheus\", prometheus_replica=\"prometheus-prometheus-kube-prometheus-prometheus-0\"}"
level=info ts=2022-11-04T16:34:46.833622864Z caller=intrumentation.go:48 msg="changing probe status" status=ready
```

### Prometheus UI

![Prometheus UI](assets/img/prometheus_ui.png)
