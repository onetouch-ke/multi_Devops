helm install alb-controller alb-controller
helm install msa_front mychart/frontend
helm install msa_boards mychart/boards
helm install msa_users mychart/users
kubectl create namespace argocd
helm repo add argo https://argoproj.github.io/argo-helm
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm install argocd argo/argo-cd -n argocd --set server.extraArgs="{--insecure}" --set server.insecure=true     # Only HTTP Health Check
helm install prometheus prometheus-community/prometheus -n monitoring --create-namespace
helm install grafana grafana/grafana -n monitoring
helm install ingress ingress
kubectl create -f argocd-msa-app.yaml