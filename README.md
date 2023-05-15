# Automated-Web-Applications-on-Amazon-EKS.

Objective: Automate infrastructure deployment and enable seamless CI/CD for a web application using Terraform, provisioning an EC2 instance, ECR, and EKS. Employ Ansible to install essential tools Jenkins, Configure Jenkins access and install necessary plugins on the EC2 instance.

## Prerequisites:
- ✅  Git
- ✅  Terraform
- ✅  Ansible
- ✅  Docker, docker compose
- ✅  Kubernetes
- ✅  AWS
- ✅  Jenkins

Prerequisites (Tools)
- Terraform [Install Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- Ansible [Installing Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

to Apply the Terraform configurationand Install Jenkins.
add this command "chmod +x automated_deployment.sh"
and than run this script "./automated_deployment.sh"


## Tasks Completed
- Used Terraform to create VPC with 3 Subnet in 2 AZs,EKS cluster with two nodes, an EC2 machine for Jenkins, ECR and run Ansible playbook for configure jenkins and plugins.
- Used Ansible to install and configure Jenkins, including necessary plugins.
- Forked the MySQL-and-Python repository and created a Docker image for the code.
- Created a Docker compose file for the code and database to run.
- kubernetes manifest file
    1. Created Kubernetes deployment files for Python code.
    2. Created ```statefulset``` files for MySQL, including PV and PVCs.
    3. Added ```services``` to expose the Python code and MySQL deployments.
    4. Configured ```ConfigMaps``` for storing code configuration data.
    5. Configured ```secrets``` to store sensitive information.
    6. Implemented ```NGINX``` controller for ingress.
- Configured Jenkins using pipeline as a code to build from GitHub on every push on all branches (GitHub webhooks) to integrate with Jenkins.
- Build the CI/CD Pipeline using Jenkins.
    - Checkout external project
    - build new Docker images
    - push the image to ECR
    - add image to the yml files app and database
    - Deploy Kubernetes manifest files. 
    - the pipeline is configured to output the URL to the website.

## To ensure a more secure environment, the following security measures were implemented in the project:

- IAM roles were utilized for EKS, EBS, and ECR.
- An IAM role was used to grant specific permissions to Jenkins, allowing it to interact with AWS services without the need to manage and store long-term access keys or secrets within Jenkins itself.
- Proper security groups and network policies were configured to control inbound and outbound traffic to the EKS cluster and worker nodes.
- Secure access controls for AWS resources were implemented, utilizing IAM roles with the principle of least privilege.