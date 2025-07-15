aws ec2 create-tags \
  --resources subnet-087e1d1d4dbf2c209 subnet-09d9108f063038213 \   # public subnet
  --tags Key=kubernetes.io/role/elb,Value=1 \
         Key=kubernetes.io/cluster/tg-Cluster,Value=shared \        # 실제 클러스터 명으로 수정

aws ec2 create-tags \
  --resources subnet-087e1d1d4dbf2c209 subnet-09d9108f063038213 \   # private subnet
  --tags Key=kubernetes.io/role/internal-elb,Value=1 \
         Key=kubernetes.io/cluster/tg-Cluster,Value=shared \        # 실제 클러스터 명으로 수정