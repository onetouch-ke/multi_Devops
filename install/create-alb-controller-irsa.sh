#!/bin/bash

# 변수 선언
CLUSTER_NAME="MSA-cluster"
REGION="ap-northeast-2"
ACCOUNT_ID="340822111750"
POLICY_NAME="AWSLoadBalancerControllerIAMPolicy"
NAMESPACE="kube-system"
POLICY_FILE="iam_policy.json" # ALB Controller 공식 정책 파일(수동 준비 또는 다운로드 필요)
ROLE_NAME="alb-controller-irsa-role"
ROLE_FILE="trust-policy.json"


# 1. OIDC Provider 연결
eksctl utils associate-iam-oidc-provider \
  --region $REGION \
  --cluster $CLUSTER_NAME \
  --approve

# 2. Policy 생성 (이미 있으면 에러 무시)
aws iam create-policy \
  --policy-name $POLICY_NAME \
  --policy-document file:///root/multi_Devops/install/$POLICY_FILE || true

# 3. 역할(Role) 생성
aws iam create-role \
  --role-name $ROLE_NAME \
  --assume-role-policy-document file:///root/multi_Devops/install/$ROLE_FILE || true

# 4. 정책 역할에 attach
aws iam attach-role-policy \
  --role-name alb-controller-irsa-role \
  --policy-arn arn:aws:iam::340822111750:policy/AWSLoadBalancerControllerIAMPolicy

# 4. alb-controller CRD 설치
kubectl create -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller//crds?ref=master"

