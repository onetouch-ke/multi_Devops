#!/bin/bash

# cert-manager 리소스 삭제
kubectl delete -f https://github.com/cert-manager/cert-manager/releases/latest/download/cert-manager.yaml

# cert-manager 관련 네임스페이스(있으면) 삭제
kubectl delete namespace cert-manager --ignore-not-found

# 남아있는 cert-manager CRD(있으면)도 삭제 (option)
kubectl delete crd certificates.cert-manager.io \
  certificaterequests.cert-manager.io \
  challenges.acme.cert-manager.io \
  clusterissuers.cert-manager.io \
  issuers.cert-manager.io \
  orders.acme.cert-manager.io --ignore-not-found

