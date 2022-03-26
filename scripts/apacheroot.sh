#!/bin/bash
# Apache2 on Ubuntu 18.04.
sleep 30
sudo su <<EOF
# 1 Prerequisites:
apt update && apt upgrade -y && apt install wget nano tree unzip git-all sshpass -y
sleep 5

# 1 Install Appache2
apt install apache2 -y
sleep 5

# 1 - Change HostName
chmod 777 /etc/hostname
echo "apache" > /etc/hostname
sudo chmod 664 /etc/hostname
sleep 5

# 1 Add users to sudoer file
sudo echo "ubuntu ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/ubuntu
sleep 5

# 1 - Enable PasswordAuthentication to Yes for all and initialhandshake with other servers via ssh keys
sed -i "/^[^#]*PasswordAuthentication[[:space:]]no/c\PasswordAuthentication yes" /etc/ssh/sshd_config
sleep 5

# 1 - set ubuntu user password and SSHPASS variable. change password later, each password must be the same.
echo 'export CICDPASS=123456' >> /etc/profile.d/exportvariable.sh
echo "ubuntu:123456" | sudo chpasswd

EOF

sleep 5
sudo -i reboot
#theEnd
