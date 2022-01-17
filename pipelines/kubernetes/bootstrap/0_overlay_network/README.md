# Link to docs

  https://docs.projectcalico.org/getting-started/kubernetes/self-managed-onprem/onpremises#install-calico-with-kubernetes-api-datastore-50-nodes-or-less

  ```bash
  curl -sL https://docs.projectcalico.org/manifests/calico.yaml -o calico-new.yaml
  diff -u calico.yaml calico-new.yaml
  ```

## Calico API server

  Install guide: https://docs.projectcalico.org/maintenance/install-apiserver

  ```bash
  curl -sL https://docs.projectcalico.org/manifests/apiserver.yaml -o apiserve-new.yaml
  diff -u apiserver.yaml apiserve-new.yaml
  ```
