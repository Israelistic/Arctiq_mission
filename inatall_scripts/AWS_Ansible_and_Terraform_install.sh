#!/bin/bash
#
#Authur: Haggai Lerman
#date: Sept 3 2018
#purpose: Demo of adialog vox that will display a menu

x="5"
MENUBOX=${MENUBOX=dialog}

funcDisplayDialogMenu () {
 $MENUBOX --title "[ M A I N  M E N U ]"  --menu "Use UP/DOWN Arrows to Move and Select or the Number of Your Choice and Enter" 15 45 4 1 "Install Ansible" 2 "Install Terraform" 3 "Install AWS CLI" 4 "Configure AWS CLI" 5 "System Info" X "Exit" 2>choice.txt
}

funcDisplayDialogMenu
case "`cat choice.txt`" in
 1) ./ansible_install_script.sh;;
 2) ./terraform_install_script.sh;;
 3) ./install_aws_cli.sh;;
 4) ./;;
 5) ./sysinop.sh;;
 X) break ;;
esac
echo $?
