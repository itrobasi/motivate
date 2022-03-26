#!/bin/bash
# Docker on Ubuntu 18.04.
sleep 30
sudo su <<EOF
# 1 Prerequisites:
apt update && sleep 5 && apt upgrade -y && apt install wget nano tree unzip git-all -y && apt install openjdk-8-jdk maven -y
sleep 5

# 1 Install Docker
apt-get remove docker docker-engine docker.io containerd runc
apt-get install ca-certificates curl gnupg lsb-release
sleep 5
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt update && apt upgrade -y
apt-get install docker-ce docker-ce-cli containerd.io -y
sleep 5

# 1 - Set ubuntu and other user password and SSHPASS variable. change password later, each password must be the same.
echo 'export CICDPASS=123456' >> /etc/profile.d/exportvariable.sh
useradd -m -p 123456 -s /bin/bash jenkins
echo "ubuntu:123456" | sudo chpasswd
sleep 5

# Add users to docker group.
uuser=`whoami`
sleep 5
usermod -aG docker $uuser
sleep 5
usermod -aG docker jenkins
sleep 5

# 1 - Change HostName
chmod 777 /etc/hostname
echo "docker" > /etc/hostname
chmod 664 /etc/hostname
sleep 5

# 1 Add users to sudoer file
echo "jenkins ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/jenkins
echo "ubuntu ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/ubuntu

# 1 - Enable PasswordAuthentication to Yes for all and initialhandshake with other servers via ssh keys
sed -i "/^[^#]*PasswordAuthentication[[:space:]]no/c\PasswordAuthentication yes" /etc/ssh/sshd_config
sleep 5

sudo chown ubuntu /var/run/docker.sock


service ssh restart

EOF

sleep 5
sudo -i reboot
#theEnd
