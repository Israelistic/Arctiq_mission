#!/usr/bin/env bash
#Auther: Hagi Lerman
#Date: Apr 28 2019
#OS: Ubuntu  18.04 Bionic Beaver LTS
#NOTE! USE WITH YOUR OWN CATUION! This script will install Ansible and Terraform for Ubuntu.
clear
set -x
if [ $USER != "root" ] #Make sure only root can use this script
then
        echo "You Must be on ROOT!"
        exit 1 #make sure exit status is 1 (ERROR)
fi
# Update repository cache
sudo apt-get -y update
# Install python pip
sudo apt install python-pip -y
# Upgrade pip -just in case
pip install --upgrade pip
# Install Terraform
curl -0 https://releases.hashicorp.com/terraform/0.11.2/terraform_0.11.2_linux_amd64.zip
# create a folder name terraform in bin directory
sudo mkdir /bin/terraform
#unzip terraform zip
sudo unzip terraform_0.11.2_linux_amd64.zip -d /bin/terraform/
# Add Terraform to our path without destorying our current PATH
sudo echo 'export PATH=:/bin/terraform:$PATH' >> ~/.bashrc
source ~/.bashrc
# check Terraform version
terraform --version
