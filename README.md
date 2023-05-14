# Automated-Web-Applications-on-Amazon-EKS.

Objective: Automate infrastructure deployment and enable seamless CI/CD for a web application using Terraform, provisioning an EC2 instance, ECR, and EKS. Employ Ansible to install essential tools Jenkins, Configure Jenkins access and install necessary plugins on the EC2 instance.

Prerequisites (Tools)
Terraform Click here to install
Ansible Click here to install

chmod +x automated_deployment.sh
./automated_deployment.sh



To specify an AWS CLI profile, run the following command:

$ aws eks update-kubeconfig --name eks-cluster-name --region aws-region --profile my-profile
$ kubectl config view --minify


Update or generate the kubeconfig file using the following command:

$ aws eks update-kubeconfig --name eks-cluster-name --region aws-region




IAM role

