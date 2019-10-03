#!/bin/bash
#
#Author: Haggai Lerman
#
#Purpose: Ansible installation and configuration.
#
#Date: 7 Sept 2018.
#
clear
set -x
if [ $USER != "root" ] #Make sure only root can use this script
then
        echo "You Must be on ROOT!"
        exit 1 #make sure exit status is 1 (ERROR)
fi
ANSIBLE_INSTALL(){ #  will install the packages to install ansible inculding ansible
 yum inatall -y epel-release
 yum install -y git python-devel python-pip openssl ansible
}
# We need to indicate the inventory which is the path of ansible
# as well as the ability to use root
EDIT_ANSIBLE_CFG(){
 cd /etc/ansible # cahnge the directory to /etc/ansible
 vim /etc/ansible/ansible.cfg #edit the ansible configuration file
}
# Backup the original hostfile and creates a new host file to be use
# we use the ansible file to indicate which user do we want to contact
# while using ansible
EDIT_ANSIBLE_HOST(){
 mv /etc/ansible/host /etc/ansible/host.original
 vim /etc/ansible/host
}
ADD_ANSIBLE_USER(){ # add a new user called ansible
 useradd ansible
}
#we need add ansible user to allow execute commands as root
CHANGE_VI_SUDO(){
visudo
#ansible        ALL=(ALL) NOPASSWD: ALL
}
COPY_SSH_ID() {
 ANSIBLE_HOSTS= ["@host.com/IP" "@host.com/IP" "@host.com/IP" ]
for HOST in "${ANSIBLE_HOSTS[@]}"

 `ssh-copy-id` localhost$HOST
}
COMMANDS_ENDPOINT(){
    # this command will ping all nodes on /etc/ansible/hosts
    ansible all -m ping
    # this command will do long lising in all nodes on home/ansible profile
    ansible all -a "ls -al /home/ansible"
    # this command will display the var/log/messages from all nodes on /ets/ansible/hosts
    ansible all -s -a "cat /var/log/messages"
    # this command will copy a file from localhost the /tmp directoy on all nodes that configure on /etc/ansible/hosts
    ansible centos -m copy -a "src=test.txt dest=/tmp/test.txt"
    # this command will install elinks on selected nodes
    ansible ubuntu -s -m  apt -a "name=elinks state=latest"
    # this command willl uninstall elinks on selected nodes
    ansible ubuntu -s -m -a "name=elinks state=absent"
}
while [ "$MENUITEM" != "Q" ] && [ "$MENUITEM != "q" ];
do
clear
    #MAIN / CASE_SWITCH
    echo "WELCOME TO ANSIBLE INSTALLER"
    echo "============================"
    echo ""
    echo ""
    echo "MAIN MENU"
    echo "========="
    echo "1)INSTALL ANSIBLE"
    echo "2)EDIT /etc/ansible.cfg"
    echo "3)EDIT /etc/ansible/host"
    echo "4)ADD ANSIBLE USER"
    echo "5)EDIT VISUDO"
    echo "6)COPY SSH_COPY_ID"
    echo "Q/q)TO EXIT"
    read MENUITEM
    case $MENUITEM in
     1)ANSIBLE_INSTALL;;
     2)EDIT_ANSIBLE_CFG;;
     3)EDIT_ANSIBLE_HOST;;
     4)ADD_ANSIBLE_USER;;
     5)CHANGE_VI_SUDO;;
     6)COPY_SSH_ID;;
    esac

done
