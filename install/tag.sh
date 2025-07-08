aws ec2 create-tags \
  --resources  subnet-00ea8fad9bb9157f7 subnet-0942ead7ba1048ede \
  --tags Key=kubernetes.io/role/elb,Value=1 \
		     Key=kubernetes.io/role/internal-elb,Value=1 \
         Key=kubernetes.io/cluster/MSA-cluster,Value=shared \
