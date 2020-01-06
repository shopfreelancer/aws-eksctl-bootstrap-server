# AWS eksctl Bootstrap Dockerfile

AWS EKS is a managed kubernetes solution. It requires quite a few tools for administration.

https://eksctl.io/ is the official tool for managing your EKS cluster on AWS. Then there is aws-cli. And kubectl. And helm.

Those can be installed locally. Or you could use a dedicated bootstrap server with all the tools installed. In this case it is a container in a Dockerfile with aws-cli, eksctl and kubectl.


## Prerequisites
1) mv docker-compose-sample.yml docker-compose.yml
2) Create AWS IAM as EKS admin user and use its credentials in docker-compose file

## Start the bootstrap server
````
docker-compose up --build
docker exec -it docker-bootstrap_eks-bootstrap_1 bash
````

## Create and manage your cluster
````
eksctl create cluster -f eks-course.yaml
kubectl get nodes
````