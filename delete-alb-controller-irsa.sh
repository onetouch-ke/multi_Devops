#!/bin/bash

# 변수 선언
CLUSTER_NAME="tg-Cluster"
REGION="ap-northeast-2"
ACCOUNT_ID="038964340463"
POLICY_NAME="AWSLoadBalancerControllerIAMPolicy"
NAMESPACE="kube-system"
SERVICE_ACCOUNT="aws-load-balancer-controller"

# 1. ServiceAccount와 연결된 IAM Role명 추출 (eksctl 네이밍 규칙 반영)
IAM_ROLE_NAME=$(aws iam list-roles \
  --query "Roles[?contains(RoleName, 'eksctl-${CLUSTER_NAME}-addon-iamserviceaccount-${NAMESPACE}-${SERVICE_ACCOUNT}')].RoleName" \
  --output text)

echo "찾은 IAM Role: $IAM_ROLE_NAME"

# 2. ServiceAccount 삭제 (Kubernetes)
echo "Kubernetes ServiceAccount 삭제..."
kubectl -n $NAMESPACE delete sa $SERVICE_ACCOUNT --ignore-not-found

# 3. IAM Role과 Policy Detach & 삭제
if [ ! -z "$IAM_ROLE_NAME" ]; then
  echo "IAM Role에 붙은 정책 분리 및 Role 삭제..."
  # 연결된 정책 분리
  ATTACHED_POLICIES=$(aws iam list-attached-role-policies --role-name "$IAM_ROLE_NAME" --query "AttachedPolicies[].PolicyArn" --output text)
  for POLICY_ARN in $ATTACHED_POLICIES; do
    aws iam detach-role-policy --role-name "$IAM_ROLE_NAME" --policy-arn "$POLICY_ARN"
  done
  # Role 삭제
  aws iam delete-role --role-name "$IAM_ROLE_NAME"
else
  echo "Role을 찾지 못했거나 이미 삭제됨"
fi

# 4. 정책(Policy)도 삭제 (다른 데서 안 쓸 때만)
echo "정책 삭제 시도..."
aws iam delete-policy --policy-arn arn:aws:iam::$ACCOUNT_ID:policy/$POLICY_NAME || true

echo "==== 리소스 삭제 완료 ===="

