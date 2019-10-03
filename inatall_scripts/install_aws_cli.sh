#!/bin/bash
#Version: 0.1
#Authur: Haggai Lerman
#date: Oct 1 2019
#purpose: will install AWS CLI
#resource: https://docs.aws.amazon.com/cli/latest/userguide/install-linux.html
#OS: Ubuntu  18.04 Bionic Beaver LTS
#NOTE! USE WITH YOUR OWN CATUION!
clear
set -x
if [ $USER != "root" ] #Make sure only root can use this script
then
        echo "You Must be on ROOT!"
        exit 1 #make sure exit status is 1 (ERROR)
fi
#Use the curl command to download the installation script.
#The following command uses the -O (capital letter O)
#parameter to specify that the downloaded file is to be stored in the current folder using the same name it has on the remote host.
curl -O https://bootstrap.pypa.io/get-pip.py
#Run the script with Python to download and install the latest version of pip and other required support packages.
python get-pip.py --user
python3 get-pip.py --user
#When you include the --user switch, the script installs pip to the path ~/.local/bin.
pip3 --version #check pip3 version
python --version# check python version
python3 --version # will check python 3 version
#add an export command at the end of your profile script that's similar to the following example.
export PATH=~/.local/bin:$PATH
#Reload the profile into your current session to put those changes into effect.
source ~/.bash_profile
pip3 --version
#Install the AWS CLI with pip
pip3 install awscli --upgrade --user
#When you use the --user switch, pip installs the AWS CLI to ~/.local/bin.
#Verify that the AWS CLI installed correctly.
aws --version
