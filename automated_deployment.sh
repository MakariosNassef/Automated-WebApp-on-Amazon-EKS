#!/bin/bash

echo "Select an option:"
echo "1. Initialize Terraform. You only need to do this once per directory.🧱"
echo "2. Review the configuration and verify that the resources that Terraform is going to create or update 🌱"
echo "3. terraform Apply: Apply the Terraform configuration 🚀"
echo "4. terraform destroy: Remove resources previously applied with your Terraform configuration 🗑️"
echo "5. Installing Jenkins and add necessary plugins Using Ansible 🔐"
echo "6. Exit"

read -p "Enter your choice: " choice

case $choice in
  1)
    terraform -chdir=infra init
    ;;
  2)
    terraform -chdir=infra plan
    ;;
  3)
    terraform -chdir=infra apply
    ;;
  4)
    terraform -chdir=infra destroy
    ;;
  5)
    echo "Make sure to modify the user name and password for the first time."
    echo "Please write username and password for Jenkins."
    read -p "Enter your Jenkins User name: " username
    read -s -p "Enter your Jenkins Password: " password
    sed -i "s|jenkins_admin_username:.*|jenkins_admin_username: $username|g" ansible_jenkins_config/vars.yml
    sed -i "s|jenkins_admin_password:.*|jenkins_admin_password: $password|g" ansible_jenkins_config/vars.yml
    sed -i "s|hudsonRealm.createAccount('.*|hudsonRealm.createAccount('$username','$password')|g"  ansible_jenkins_config/security.groovy.j2
    export EC2_PUB=$(cat infra/terraform.tfstate |grep -w INSTANCE_PUBLIC_IP_OUTPUT_MODULE -A1 | grep -v INSTANCE_PUBLIC_IP_OUTPUT_MODULE | cut -d '"' -f4)
    ansible-playbook -i "$EC2_PUB," -u ubuntu --private-key ~/Downloads/jenkins-keypair2.pem  ansible_jenkins_config/tasks/main.yml
    ;;
  6)
    echo "Exiting..."
    exit 0
    ;;
  *)
    echo "Invalid choice!"
    exit 1
    ;;
esac
