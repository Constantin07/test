# ArgoCD

## Install ArgoCD

Run `make deploy` 
The default values can be found [here](https://github.com/argoproj/argo-helm/blob/main/charts/argo-cd/values.yaml)

## Get admin password for UI

kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

## Bootstrap ArgoCD

Run `make bootsrap`
