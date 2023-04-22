#/bin/bash
sudo apt-get update
sudo apt-get install -y unzip jq
AVAIL_ZONE=`curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone`
REGION="`echo \"$AVAIL_ZONE\" | sed 's/[a-z]$//'`"
ACC_ID=`curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .accountId`
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install  
aws cloudformation create-stack --stack-name EKS --template-url https://pc-schandu.s3.amazonaws.com/eks.yaml --capabilities CAPABILITY_NAMED_IAM --region $REGION
sleep 10
aws cloudformation wait stack-create-complete --stack-name EKS --region $REGION
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.24.11/2023-03-17/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo cp ./kubectl /usr/bin/kubectl
aws eks update-kubeconfig --region $REGION --name prisma-eks
wget https://raw.githubusercontent.com/chanduusc/prisma-codebuild-demo/main/aws-auth.yaml
sed -i 's/12345678/'"$ACC_ID"'/g' aws-auth.yaml
kubectl apply -f aws-auth.yaml
kubectl apply -f https://raw.githubusercontent.com/chanduusc/prisma-codebuild-demo/main/eks-deployment.yml
kubectl apply -f https://raw.githubusercontent.com/chanduusc/prisma-codebuild-demo/main/loadbalancer.yaml