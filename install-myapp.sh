helm install alb-controller alb-controller
helm install myapp 3-tier-chart
kubectl create namespace argocd
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
helm install argocd argo/argo-cd -n argocd
helm install ingress ingress
