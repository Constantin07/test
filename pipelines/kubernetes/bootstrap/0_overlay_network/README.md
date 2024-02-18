# Link to docs

https://docs.projectcalico.org/getting-started/kubernetes/self-managed-onprem/onpremises#install-calico-with-kubernetes-api-datastore-50-nodes-or-less

```sh
curl -sL https://raw.githubusercontent.com/projectcalico/calico/v3.27.2/manifests/calico.yaml -o calico-new.yaml
diff -u calico.yaml calico-new.yaml
```

## Calico API server

Install guide: https://docs.tigera.io/calico/latest/operations/install-apiserver#install-the-api-server

```sh
curl -sL https://raw.githubusercontent.com/projectcalico/calico/v3.27.2/manifests/apiserver.yaml -o apiserver-new.yaml
diff -u apiserver.yaml apiserver-new.yaml
```
