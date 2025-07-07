#!/bin/bash

# 변수 선언
CLUSTER_NAME="tg-Cluster"
REGION="ap-northeast-2"
ACCOUNT_ID="038964340463"
POLICY_NAME="AWSLoadBalancerControllerIAMPolicy"
NAMESPACE="kube-system"
SERVICE_ACCOUNT="aws-load-balancer-controller"
POLICY_FILE="iam_policy.json" # ALB Controller 공식 정책 파일(수동 준비 또는 다운로드 필요)

# 1. OIDC Provider 연결
eksctl utils associate-iam-oidc-provider \
  --region $REGION \
  --cluster $CLUSTER_NAME \
  --approve

# 2. Policy 생성 (이미 있으면 에러 무시)
aws iam create-policy \
  --policy-name $POLICY_NAME \
  --policy-document file:///root/project/install/$POLICY_FILE || true

# 3. ServiceAccount + IAM Role 연결 (이미 있으면 override)
eksctl create iamserviceaccount \
  --cluster $CLUSTER_NAME \
  --region $REGION \
  --namespace $NAMESPACE \
  --name $SERVICE_ACCOUNT \
  --attach-policy-arn arn:aws:iam::$ACCOUNT_ID:policy/$POLICY_NAME \
  --override-existing-serviceaccounts \
  --approve

