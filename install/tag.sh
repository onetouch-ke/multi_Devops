aws ec2 create-tags \
  --resources subnet-087e1d1d4dbf2c209 subnet-09d9108f063038213 \
  --tags Key=kubernetes.io/role/elb,Value=1 \
		     Key=kubernetes.io/role/internal-elb,Value=1 \
         Key=kubernetes.io/cluster/tg-Cluster,Value=shared \
